import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/bookings/data/models/time_slot_model.dart';

/// Remote data source for time slot availability operations.
///
/// Handles:
/// - Getting available time slots for a field on a specific date
/// - Checking if a specific time slot is available
abstract class BookingTimeSlotDataSource {
  Future<List<TimeSlotModel>> getAvailableTimeSlots({
    required String fieldId,
    required DateTime date,
  });

  Future<bool> isTimeSlotAvailable({
    required String fieldId,
    required DateTime date,
    required String startTime,
    required String endTime,
  });
}

/// Implementation of booking time slot data source.
class BookingTimeSlotDataSourceImpl implements BookingTimeSlotDataSource {
  final SupabaseClient supabaseClient;

  BookingTimeSlotDataSourceImpl({required this.supabaseClient});

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
