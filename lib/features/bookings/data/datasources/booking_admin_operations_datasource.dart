import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/bookings/data/models/booking_model.dart';

/// Remote data source for super admin booking operations.
///
/// Handles:
/// - Getting all bookings across all fields (platform-wide)
/// - Auto-completing expired bookings via RPC
abstract class BookingAdminOperationsDataSource {
  Future<List<BookingModel>> getAllBookings();

  /// Call Supabase RPC to auto-complete passed bookings.
  /// Returns the number of bookings that were updated.
  Future<int> completePassedBookings();
}

/// Implementation of booking admin operations data source.
class BookingAdminOperationsDataSourceImpl
    implements BookingAdminOperationsDataSource {
  final SupabaseClient supabaseClient;

  BookingAdminOperationsDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<BookingModel>> getAllBookings() async {
    try {
      debugPrint('📖 Fetching all bookings (Super Admin)');

      // Use the optimized view to get all bookings with details
      final response = await supabaseClient
          .from('user_bookings_with_details')
          .select()
          .order('booking_date', ascending: false)
          .order('start_time', ascending: false);

      final bookings = (response as List)
          .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
          .toList();

      debugPrint('✅ Found ${bookings.length} total bookings');

      return bookings;
    } on PostgrestException catch (e) {
      debugPrint('❌ PostgrestException in getAllBookings: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ Exception in getAllBookings: $e');
      throw ServerException('Failed to load all bookings: $e');
    }
  }

  @override
  Future<int> completePassedBookings() async {
    try {
      debugPrint('🔄 Calling RPC to complete passed bookings...');

      // Call the Supabase RPC function
      final response = await supabaseClient.rpc('complete_passed_bookings');

      final count = response as int? ?? 0;
      debugPrint('✅ Auto-completed $count bookings');

      return count;
    } on PostgrestException catch (e) {
      debugPrint(
        '❌ PostgrestException in completePassedBookings: ${e.message}',
      );
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ Exception in completePassedBookings: $e');
      throw ServerException('Failed to complete passed bookings: $e');
    }
  }
}
