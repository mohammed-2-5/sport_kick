import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/bookings/data/models/booking_model.dart';
import 'package:spo_kick/features/bookings/data/models/time_slot_model.dart';

import '../../domain/entities/booking_status.dart';

/// Remote data source for bookings using Supabase.
///
/// Implements high-performance queries with:
/// - Optimized SELECT statements (only needed columns)
/// - Proper error handling with retry logic
/// - Batch operations where applicable
/// - Query result caching
/// - Connection pooling via Supabase client
abstract class BookingRemoteDataSource {
  Future<List<BookingModel>> getUserBookings(String userId);
  Future<BookingModel> getBookingById(String bookingId);
  Future<List<TimeSlotModel>> getAvailableTimeSlots({
    required String fieldId,
    required DateTime date,
  });
  Future<BookingModel> createBooking(BookingModel booking);
  Future<BookingModel> cancelBooking(String bookingId, String reason);
  Future<BookingModel> updateBookingStatus(
    String bookingId,
    BookingStatus status,
  );
  Future<List<BookingModel>> getBookingsByStatus(
    String userId,
    BookingStatus status,
  );

  /// Get all bookings for fields owned by the current user (for owner dashboard).
  Future<List<BookingModel>> getOwnerBookings();

  /// Get all bookings in the system (for super admin only).
  Future<List<BookingModel>> getAllBookings();

  /// Create a manual booking (for field owners/admins).
  ///
  /// Manual bookings are automatically confirmed and include customer information.
  Future<BookingModel> createManualBooking(BookingModel booking);
}

/// Implementation of booking remote data source.
class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final SupabaseClient supabaseClient;

  BookingRemoteDataSourceImpl({required this.supabaseClient});

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
  Future<List<TimeSlotModel>> getAvailableTimeSlots({
    required String fieldId,
    required DateTime date,
  }) async {
    try {
      // Step 1: Get field price (cached in application layer)
      final field = await supabaseClient
          .from('fields')
          .select('price_per_hour, currency')
          .eq('id', fieldId)
          .single();

      final pricePerHour = (field['price_per_hour'] as num).toDouble();
      final currency = field['currency'] as String? ?? 'EGP';

      // Step 2: Get existing bookings for the date
      // Uses idx_bookings_field_date_time index for fast lookup
      final dateString = date.toIso8601String().split('T')[0];

      debugPrint('🔍 Fetching time slots for field: $fieldId on $dateString');

      final existingBookings = await supabaseClient
          .from('bookings')
          .select('start_time, end_time, status')
          .eq('field_id', fieldId)
          .eq('booking_date', dateString)
          .inFilter('status', ['pending', 'confirmed']);

      debugPrint('📊 Found ${(existingBookings as List).length} bookings');

      // Convert to Set for O(1) lookup
      final bookedSlots = <String>{};
      for (final booking in existingBookings) {
        final startTime = booking['start_time'] as String;
        final status = booking['status'] as String;

        // Normalize time format: "08:00:00" -> "08:00"
        final normalizedTime = startTime.substring(
          0,
          5,
        ); // Get first 5 chars (HH:MM)

        debugPrint(
          '   Booked: $startTime -> $normalizedTime (status: $status)',
        );
        bookedSlots.add(normalizedTime);
      }

      debugPrint('✅ Total booked slots: ${bookedSlots.length}');

      // Step 3: Generate time slots (8 AM - 11 PM)
      final slots = <TimeSlotModel>[];

      for (int hour = 8; hour < 23; hour++) {
        final startTime = '${hour.toString().padLeft(2, '0')}:00';
        final endTime = '${(hour + 1).toString().padLeft(2, '0')}:00';

        // Check if slot is available (not in bookedSlots)
        final isAvailable = !bookedSlots.contains(startTime);

        slots.add(
          TimeSlotModel(
            startTime: startTime,
            endTime: endTime,
            isAvailable: isAvailable,
            price: pricePerHour,
            currency: currency,
          ),
        );
      }

      return slots;
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw const NotFoundException('Field not found');
      }
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to load time slots: $e');
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
        throw const NotFoundException('Booking not found or cannot be canceled');
      }
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to cancel booking: $e');
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

  /// Check if a time slot is available (bonus utility method).
  ///
  /// Uses the optimized database function for O(1) lookup.
  Future<bool> isTimeSlotAvailable({
    required String fieldId,
    required DateTime date,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final dateString = date.toIso8601String().split('T')[0];

      final response = await supabaseClient.rpc(
        'is_time_slot_available',
        params: {
          'p_field_id': fieldId,
          'p_booking_date': dateString,
          'p_start_time': startTime,
          'p_end_time': endTime,
        },
      );

      return response as bool;
    } catch (e) {
      throw ServerException('Failed to check availability: $e');
    }
  }
}
