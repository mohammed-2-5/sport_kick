import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/bookings/data/models/time_slot_model.dart';

/// Remote data source for time slot availability operations.
///
/// Handles:
/// - Getting available time slots for a field on a specific date
/// - Checking if a specific time slot is available
/// - Supports cross-midnight business hours (e.g., 12 PM - 2 AM)
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

  /// Check if consecutive time slots are available for 2-hour booking
  Future<bool> areConsecutiveSlotsAvailable({
    required String fieldId,
    required DateTime date,
    required String startTime,
    required int durationHours,
    required bool isNextDay,
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
      // Step 1: Get field price
      final field = await supabaseClient
          .from('fields')
          .select('price_per_hour, currency')
          .eq('id', fieldId)
          .single();

      final pricePerHour = (field['price_per_hour'] as num).toDouble();
      final currency = field['currency'] as String? ?? 'EGP';

      // Step 2: Get business hours for the day
      final dayOfWeek = date.weekday % 7; // 0=Sunday, 1=Monday, etc.
      final businessHours = await _getBusinessHoursForDay(fieldId, dayOfWeek);

      if (businessHours == null || !businessHours['is_open']) {
        debugPrint('📅 Field is closed on this day');
        return [];
      }

      // Parse business hours
      final openingTime = _parseTime(businessHours['opening_time'] as String?);
      final closingTime = _parseTime(businessHours['closing_time'] as String?);
      final closesNextDay = businessHours['closes_next_day'] as bool? ?? false;

      debugPrint(
        '🕐 Business hours: ${openingTime?.hour}:00 - ${closingTime?.hour}:00 '
        '(closesNextDay: $closesNextDay)',
      );

      // Step 3: Get existing bookings for the date (and next day if cross-midnight)
      final dateString = date.toIso8601String().split('T')[0];
      final nextDateString = date
          .add(const Duration(days: 1))
          .toIso8601String()
          .split('T')[0];

      debugPrint('🔍 Fetching time slots for field: $fieldId on $dateString');

      // Fetch bookings for current date
      final currentDayBookings = await supabaseClient
          .from('bookings')
          .select('start_time, end_time, status, booking_date')
          .eq('field_id', fieldId)
          .eq('booking_date', dateString)
          .inFilter('status', ['pending', 'confirmed']);

      // Convert to Sets for O(1) lookup
      final bookedSlotsCurrentDay = <String>{};
      for (final booking in currentDayBookings as List) {
        final startTime = booking['start_time'] as String;
        final normalizedTime = startTime.substring(0, 5);
        bookedSlotsCurrentDay.add(normalizedTime);
      }

      // If cross-midnight, also fetch next day bookings
      final bookedSlotsNextDay = <String>{};
      if (closesNextDay) {
        final nextDayBookings = await supabaseClient
            .from('bookings')
            .select('start_time, end_time, status, booking_date')
            .eq('field_id', fieldId)
            .eq('booking_date', nextDateString)
            .inFilter('status', ['pending', 'confirmed']);

        for (final booking in nextDayBookings as List) {
          final startTime = booking['start_time'] as String;
          final normalizedTime = startTime.substring(0, 5);
          bookedSlotsNextDay.add(normalizedTime);
        }
      }

      debugPrint(
        '📊 Booked slots - current day: ${bookedSlotsCurrentDay.length}, '
        'next day: ${bookedSlotsNextDay.length}',
      );

      // Step 4: Generate time slots based on business hours
      final slots = <TimeSlotModel>[];

      if (openingTime != null && closingTime != null) {
        // Generate same-day slots (from opening to midnight or closing, whichever is earlier)
        final sameDayEndHour = closesNextDay ? 24 : closingTime.hour;

        for (int hour = openingTime.hour; hour < sameDayEndHour; hour++) {
          final startTime = '${hour.toString().padLeft(2, '0')}:00';
          final endTime = '${((hour + 1) % 24).toString().padLeft(2, '0')}:00';
          final isAvailable = !bookedSlotsCurrentDay.contains(startTime);

          slots.add(
            TimeSlotModel(
              startTime: startTime,
              endTime: endTime,
              isAvailable: isAvailable,
              price: pricePerHour,
              currency: currency,
              isNextDay: false,
            ),
          );
        }

        // Generate next-day slots (from midnight to closing time) if cross-midnight
        if (closesNextDay) {
          for (int hour = 0; hour < closingTime.hour; hour++) {
            final startTime = '${hour.toString().padLeft(2, '0')}:00';
            final endTime = '${(hour + 1).toString().padLeft(2, '0')}:00';
            final isAvailable = !bookedSlotsNextDay.contains(startTime);

            slots.add(
              TimeSlotModel(
                startTime: startTime,
                endTime: endTime,
                isAvailable: isAvailable,
                price: pricePerHour,
                currency: currency,
                isNextDay: true,
              ),
            );
          }
        }
      }

      debugPrint('✅ Generated ${slots.length} time slots');
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

  /// Get business hours for a specific day of the week.
  Future<Map<String, dynamic>?> _getBusinessHoursForDay(
    String fieldId,
    int dayOfWeek,
  ) async {
    try {
      final response = await supabaseClient
          .from('business_hours')
          .select()
          .eq('field_id', fieldId)
          .eq('day_of_week', dayOfWeek)
          .maybeSingle();

      if (response != null) {
        return response;
      }

      // Return default hours if no custom hours set
      return {
        'is_open': true,
        'opening_time': '08:00:00',
        'closing_time': '23:00:00',
        'closes_next_day': false,
      };
    } catch (e) {
      debugPrint('[TimeSlotDS] Error fetching business hours: $e');
      // Return default hours on error
      return {
        'is_open': true,
        'opening_time': '08:00:00',
        'closing_time': '23:00:00',
        'closes_next_day': false,
      };
    }
  }

  /// Parse time string (HH:MM:SS or HH:MM) to DateTime components.
  DateTime? _parseTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;
    try {
      final parts = timeString.split(':');
      return DateTime(2000, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
    } catch (e) {
      return null;
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

  @override
  Future<bool> areConsecutiveSlotsAvailable({
    required String fieldId,
    required DateTime date,
    required String startTime,
    required int durationHours,
    required bool isNextDay,
  }) async {
    try {
      // Calculate the actual date for the booking
      final bookingDate = isNextDay ? date.add(const Duration(days: 1)) : date;
      final dateString = bookingDate.toIso8601String().split('T')[0];

      // Parse start hour
      final startHour = int.parse(startTime.split(':')[0]);

      // Check each consecutive slot
      for (int i = 0; i < durationHours; i++) {
        final slotHour = (startHour + i) % 24;
        final slotStartTime = '${slotHour.toString().padLeft(2, '0')}:00';

        // Check if crossing midnight during duration
        String checkDateString = dateString;
        if (isNextDay && slotHour < startHour) {
          // This shouldn't happen in normal flow but handle it
          checkDateString = bookingDate
              .add(const Duration(days: 1))
              .toIso8601String()
              .split('T')[0];
        }

        // Check for existing bookings
        final existingBooking = await supabaseClient
            .from('bookings')
            .select('id')
            .eq('field_id', fieldId)
            .eq('booking_date', checkDateString)
            .eq('start_time', '$slotStartTime:00')
            .inFilter('status', ['pending', 'confirmed'])
            .maybeSingle();

        if (existingBooking != null) {
          debugPrint(
            '❌ Slot $slotStartTime on $checkDateString is already booked',
          );
          return false;
        }
      }

      debugPrint(
        '✅ All $durationHours consecutive slots starting from $startTime are available',
      );
      return true;
    } catch (e) {
      throw ServerException('Failed to check consecutive availability: $e');
    }
  }
}
