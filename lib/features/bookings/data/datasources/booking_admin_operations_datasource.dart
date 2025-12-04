import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/bookings/data/models/booking_model.dart';

/// Remote data source for super admin booking operations.
///
/// Handles:
/// - Getting all bookings across all fields (platform-wide)
abstract class BookingAdminOperationsDataSource {
  Future<List<BookingModel>> getAllBookings();
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
}
