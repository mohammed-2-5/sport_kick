import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/bookings/data/models/booking_model.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';

/// Remote data source for field owner booking operations.
///
/// Handles:
/// - Getting bookings for fields owned by current user
/// - Creating manual bookings (walk-in customers)
/// - Updating booking status (approve/reject)
abstract class BookingOwnerOperationsDataSource {
  Future<List<BookingModel>> getOwnerBookings();
  Future<BookingModel> createManualBooking(BookingModel booking);
  Future<BookingModel> updateBookingStatus(
    String bookingId,
    BookingStatus status,
  );
}

/// Implementation of booking owner operations data source.
class BookingOwnerOperationsDataSourceImpl
    implements BookingOwnerOperationsDataSource {
  final SupabaseClient supabaseClient;

  BookingOwnerOperationsDataSourceImpl({required this.supabaseClient});

  /// Get current user ID from Supabase auth.
  String get _currentUserId {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw const AuthenticationException('User not authenticated');
    }
    return user.id;
  }

  @override
  Future<List<BookingModel>> getOwnerBookings() async {
    try {
      final ownerId = _currentUserId;

      debugPrint('📖 Fetching bookings for owner: $ownerId');

      // First, get the field IDs owned by this user
      final fieldsResponse = await supabaseClient
          .from('fields')
          .select('id')
          .eq('owner_id', ownerId);

      final fieldIds = (fieldsResponse as List)
          .map((field) => field['id'] as String)
          .toList();

      debugPrint('📊 Owner has ${fieldIds.length} fields');

      if (fieldIds.isEmpty) {
        debugPrint('⚠️ No fields found for owner');
        return [];
      }

      // Use the optimized view to get bookings with all details
      final response = await supabaseClient
          .from('user_bookings_with_details')
          .select()
          .inFilter('field_id', fieldIds)
          .order('booking_date', ascending: false)
          .order('start_time', ascending: false);

      final bookings = (response as List)
          .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
          .toList();

      debugPrint('✅ Found ${bookings.length} bookings for owner');
      if (bookings.isNotEmpty) {
        debugPrint(
          '   First booking: ${bookings.first.fieldName} - ${bookings.first.status.displayName}',
        );
      }

      return bookings;
    } on PostgrestException catch (e) {
      debugPrint('❌ PostgrestException in getOwnerBookings: ${e.message}');
      debugPrint('   Code: ${e.code}');
      debugPrint('   Details: ${e.details}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ Exception in getOwnerBookings: $e');
      throw ServerException('Failed to load owner bookings: $e');
    }
  }

  @override
  Future<BookingModel> createManualBooking(BookingModel booking) async {
    try {
      // Get insert JSON and ensure manual booking fields are set
      final insertData = booking.toInsertJson();

      // Set the admin user ID who is creating the booking
      insertData['created_by'] = _currentUserId;

      // For manual bookings, we use a placeholder user_id (the admin's ID)
      // The actual customer info is in customer_name, customer_phone, customer_email
      insertData['user_id'] = _currentUserId;

      debugPrint('📝 Creating manual booking by admin: $_currentUserId');
      debugPrint(
        '📝 Customer: ${booking.customerName} (${booking.customerPhone})',
      );
      debugPrint('📝 Booking data: $insertData');

      // Insert new manual booking
      // The trigger check_booking_conflict() will prevent double bookings
      final response = await supabaseClient
          .from('bookings')
          .insert(insertData)
          .select('*, field:fields(name, images)')
          .single();

      debugPrint('✅ Manual booking created successfully: ${response['id']}');

      // Parse response and include field details
      final json = response;

      // Extract field details from join
      final fieldData = json['field'] as Map<String, dynamic>?;
      if (fieldData != null) {
        json['field_name'] = fieldData['name'];
        final images = fieldData['images'] as List?;
        json['field_image'] = (images != null && images.isNotEmpty)
            ? images.first
            : null;
      }

      return BookingModel.fromJson(json);
    } on PostgrestException catch (e) {
      debugPrint('❌ PostgrestException in createManualBooking: ${e.message}');
      debugPrint('   Code: ${e.code}');

      // Handle specific error codes
      if (e.code == '23P01') {
        // exclusion_violation - double booking
        throw const ConflictException('This time slot is already booked');
      } else if (e.code == '23503') {
        // foreign_key_violation
        throw const ValidationException('Invalid field ID');
      } else if (e.code == '23514') {
        // check_violation
        throw ValidationException('Invalid booking data: ${e.message}');
      }
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ Exception in createManualBooking: $e');
      throw ServerException('Failed to create manual booking: $e');
    }
  }

  @override
  Future<BookingModel> updateBookingStatus(
    String bookingId,
    BookingStatus status,
  ) async {
    try {
      // Update booking status (for field owners/admins)
      final updateData = {
        'status': status.toShortString(),
        if (status == BookingStatus.confirmed)
          'confirmed_at': DateTime.now().toIso8601String(),
      };

      final response = await supabaseClient
          .from('bookings')
          .update(updateData)
          .eq('id', bookingId)
          .select('*, field:fields(name, images)')
          .single();

      final json = response;

      // Extract field details
      final fieldData = json['field'] as Map<String, dynamic>?;
      if (fieldData != null) {
        json['field_name'] = fieldData['name'];
        final images = fieldData['images'] as List?;
        json['field_image'] = (images != null && images.isNotEmpty)
            ? images.first
            : null;
      }

      return BookingModel.fromJson(json);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw const NotFoundException('Booking not found');
      }
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to update booking: $e');
    }
  }
}
