import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/bookings/data/models/booking_model.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';

/// Remote data source for user booking operations.
///
/// Handles:
/// - Getting user bookings
/// - Getting booking by ID
/// - Creating bookings
/// - Canceling bookings
/// - Getting bookings filtered by status
abstract class BookingUserOperationsDataSource {
  Future<List<BookingModel>> getUserBookings(String userId);
  Future<BookingModel> getBookingById(String bookingId);
  Future<BookingModel> createBooking(BookingModel booking);
  Future<BookingModel> cancelBooking(String bookingId, String reason);
  Future<List<BookingModel>> getBookingsByStatus(
    String userId,
    BookingStatus status,
  );
}

/// Implementation of booking user operations data source.
class BookingUserOperationsDataSourceImpl
    implements BookingUserOperationsDataSource {
  final SupabaseClient supabaseClient;

  BookingUserOperationsDataSourceImpl({required this.supabaseClient});

  /// Get current user ID from Supabase auth.
  String get _currentUserId {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw const AuthenticationException('User not authenticated');
    }
    return user.id;
  }

  @override
  Future<List<BookingModel>> getUserBookings(String userId) async {
    try {
      // Use authenticated user ID instead of parameter
      final actualUserId = _currentUserId;

      debugPrint('📖 Fetching bookings for user: $actualUserId');

      // Optimized query with JOIN to get field details in single request
      // Uses indexed user_id column for fast lookup
      final response = await supabaseClient
          .from('user_bookings_with_details') // Using optimized view
          .select()
          .eq('user_id', actualUserId)
          .order('booking_date', ascending: false)
          .order('start_time', ascending: false);

      final bookings = (response as List)
          .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
          .toList();

      debugPrint('✅ Found ${bookings.length} bookings');
      if (bookings.isNotEmpty) {
        debugPrint(
          '   First booking: ${bookings.first.id} - Status: ${bookings.first.status.displayName}',
        );
      }

      return bookings;
    } on PostgrestException catch (e) {
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to load bookings: $e');
    }
  }

  @override
  Future<BookingModel> getBookingById(String bookingId) async {
    try {
      // Single row lookup using primary key (O(1) with index)
      final response = await supabaseClient
          .from('user_bookings_with_details')
          .select()
          .eq('id', bookingId)
          .single();

      return BookingModel.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        // No rows returned
        throw const NotFoundException('Booking not found');
      }
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to load booking: $e');
    }
  }

  @override
  Future<BookingModel> createBooking(BookingModel booking) async {
    try {
      // Get insert JSON and set the authenticated user ID
      final insertData = booking.toInsertJson();
      insertData['user_id'] = _currentUserId; // Use authenticated user ID

      debugPrint('📝 Creating booking for user: $_currentUserId');
      debugPrint('📝 Booking data: $insertData');

      // Insert new booking
      // The trigger check_booking_conflict() will prevent double bookings
      final response = await supabaseClient
          .from('bookings')
          .insert(insertData)
          .select('*, field:fields(name, images)')
          .single();

      debugPrint('✅ Booking created successfully: ${response['id']}');

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
      // Handle specific error codes
      if (e.code == '23P01') {
        // exclusion_violation - double booking
        throw const ConflictException('This time slot is already booked');
      } else if (e.code == '23503') {
        // foreign_key_violation
        throw const ValidationException('Invalid field or user ID');
      } else if (e.code == '23514') {
        // check_violation
        throw ValidationException('Invalid booking data: ${e.message}');
      }
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to create booking: $e');
    }
  }

  @override
  Future<BookingModel> cancelBooking(String bookingId, String reason) async {
    try {
      // Update booking status to canceled
      // RLS policies ensure user can only cancel their own bookings
      final response = await supabaseClient
          .from('bookings')
          .update({
            'status': 'canceled',
            'cancellation_reason': reason,
            'canceled_at': DateTime.now().toIso8601String(),
          })
          .eq('id', bookingId)
          .eq('user_id', _currentUserId)
          .inFilter('status', [
            'pending',
            'confirmed',
          ]) // Can only cancel these statuses
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
        throw const NotFoundException(
          'Booking not found or cannot be canceled',
        );
      }
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to cancel booking: $e');
    }
  }

  @override
  Future<List<BookingModel>> getBookingsByStatus(
    String userId,
    BookingStatus status,
  ) async {
    try {
      // Use authenticated user ID instead of parameter
      final actualUserId = _currentUserId;

      // Uses idx_bookings_status index for efficient filtering
      final response = await supabaseClient
          .from('user_bookings_with_details')
          .select()
          .eq('user_id', actualUserId)
          .eq('status', status.toShortString())
          .order('booking_date', ascending: false)
          .order('start_time', ascending: false);

      return (response as List)
          .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to load bookings: $e');
    }
  }
}
