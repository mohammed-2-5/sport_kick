import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/repositories/booking_repository.dart';
import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';
import 'package:spo_kick/features/business_hours/domain/repositories/business_hours_repository.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';
import 'package:spo_kick/features/owner/presentation/cubit/booking_table/booking_table_state.dart';

/// Cubit for managing the booking table screen.
///
/// Handles:
/// - Loading owner's fields
/// - Week navigation (Saturday to Friday)
/// - Loading business hours for selected field
/// - Loading bookings for the selected week
/// - Mapping bookings to grid slots
class BookingTableCubit extends Cubit<BookingTableState> {
  final FieldRepository _fieldRepository;
  final BookingRepository _bookingRepository;
  final BusinessHoursRepository _businessHoursRepository;
  final String ownerId;

  BookingTableCubit({
    required FieldRepository fieldRepository,
    required BookingRepository bookingRepository,
    required BusinessHoursRepository businessHoursRepository,
    required this.ownerId,
  }) : _fieldRepository = fieldRepository,
       _bookingRepository = bookingRepository,
       _businessHoursRepository = businessHoursRepository,
       super(const BookingTableInitial());

  /// Initialize the booking table with owner's fields.
  Future<void> initialize() async {
    emit(const BookingTableLoading(message: 'Loading fields...'));

    try {
      debugPrint(
        '🔍 [BookingTableCubit] Initializing with ownerId: "$ownerId"',
      );

      if (ownerId.isEmpty) {
        emit(
          const BookingTableError('Owner ID is missing. Please log in again.'),
        );
        return;
      }

      // Get owner's fields
      final fieldsResult = await _fieldRepository.getFieldsByOwner(ownerId);

      final fields = fieldsResult.fold(
        (failure) {
          debugPrint(
            '❌ [BookingTableCubit] getFieldsByOwner failed: ${failure.message}',
          );
          return <FieldEntity>[];
        },
        (fieldsList) {
          debugPrint('✅ [BookingTableCubit] Found ${fieldsList.length} fields');
          return fieldsList;
        },
      );

      if (fields.isEmpty) {
        emit(
          const BookingTableError(
            'No fields found for this owner. Please add a field first.',
          ),
        );
        return;
      }

      // Select first field and load its data
      final selectedField = fields.first;
      final weekStart = _getWeekStart(DateTime.now());

      await _loadFieldData(selectedField, weekStart, fields);
    } catch (e) {
      debugPrint('❌ [BookingTableCubit] Error initializing: $e');
      emit(BookingTableError('Failed to load data: $e'));
    }
  }

  /// Change the selected field.
  Future<void> selectField(FieldEntity field) async {
    final currentState = state;
    if (currentState is! BookingTableLoaded) return;

    emit(currentState.copyWith(isRefreshing: true));

    await _loadFieldData(
      field,
      currentState.weekStartDate,
      currentState.ownerFields,
    );
  }

  /// Navigate to previous week.
  Future<void> previousWeek() async {
    final currentState = state;
    if (currentState is! BookingTableLoaded) return;

    final newWeekStart = currentState.weekStartDate.subtract(
      const Duration(days: 7),
    );
    emit(currentState.copyWith(isRefreshing: true));

    await _loadFieldData(
      currentState.selectedField,
      newWeekStart,
      currentState.ownerFields,
    );
  }

  /// Navigate to next week.
  Future<void> nextWeek() async {
    final currentState = state;
    if (currentState is! BookingTableLoaded) return;

    final newWeekStart = currentState.weekStartDate.add(
      const Duration(days: 7),
    );
    emit(currentState.copyWith(isRefreshing: true));

    await _loadFieldData(
      currentState.selectedField,
      newWeekStart,
      currentState.ownerFields,
    );
  }

  /// Navigate to current week.
  Future<void> goToToday() async {
    final currentState = state;
    if (currentState is! BookingTableLoaded) return;

    final todayWeekStart = _getWeekStart(DateTime.now());
    emit(currentState.copyWith(isRefreshing: true));

    await _loadFieldData(
      currentState.selectedField,
      todayWeekStart,
      currentState.ownerFields,
    );
  }

  /// Refresh current data.
  Future<void> refresh() async {
    final currentState = state;
    if (currentState is! BookingTableLoaded) return;

    emit(currentState.copyWith(isRefreshing: true));

    await _loadFieldData(
      currentState.selectedField,
      currentState.weekStartDate,
      currentState.ownerFields,
    );
  }

  /// Load field data (business hours and bookings).
  Future<void> _loadFieldData(
    FieldEntity field,
    DateTime weekStart,
    List<FieldEntity> ownerFields,
  ) async {
    try {
      // Load business hours
      final businessHours = await _loadBusinessHours(field.id);

      // Load bookings for the week
      final bookingSlots = await _loadWeekBookings(field.id, weekStart);

      emit(
        BookingTableLoaded(
          selectedField: field,
          ownerFields: ownerFields,
          weekStartDate: weekStart,
          businessHours: businessHours,
          bookingSlots: bookingSlots,
          isRefreshing: false,
        ),
      );
    } catch (e) {
      debugPrint('❌ [BookingTableCubit] Error loading field data: $e');
      emit(BookingTableError('Failed to load field data: $e'));
    }
  }

  /// Load business hours for a field.
  Future<List<BusinessHoursEntity>> _loadBusinessHours(String fieldId) async {
    final result = await _businessHoursRepository.getFieldBusinessHours(
      fieldId,
    );

    return result.fold(
      (failure) {
        debugPrint(
          '❌ [BookingTableCubit] Failed to load business hours: ${failure.message}',
        );
        // If backend reports missing business hours, allow UI to render
        // and prompt the owner to configure them instead of throwing.
        final msg = failure.message.toLowerCase();
        if (msg.contains('no business hours')) {
          return <BusinessHoursEntity>[];
        }

        throw Exception('Failed to load business hours: ${failure.message}');
      },
      (hoursList) {
        // If no hours configured, show helpful error
        if (hoursList.isEmpty) {
          debugPrint(
            '⚠️ [BookingTableCubit] No business hours configured for field $fieldId',
          );
          return <BusinessHoursEntity>[];
        }
        return hoursList;
      },
    );
  }

  /// Load bookings for a specific week and map to slots.
  Future<Map<String, BookingEntity?>> _loadWeekBookings(
    String fieldId,
    DateTime weekStart,
  ) async {
    // Get all bookings for owner and filter by field and date range
    final result = await _bookingRepository.getOwnerBookings();

    return result.fold(
      (failure) {
        debugPrint(
          '⚠️ [BookingTableCubit] Failed to load bookings: ${failure.message}',
        );
        return {};
      },
      (bookings) {
        // Week runs from Saturday to Friday (7 days total)
        // weekEnd should be the end of Friday (beginning of next Saturday)
        final weekEnd = weekStart.add(const Duration(days: 7));
        final Map<String, BookingEntity?> slots = {};

        debugPrint(
          '🔍 [BookingTableCubit] ========================================',
        );
        debugPrint('🏟️ [BookingTableCubit] Selected field ID: $fieldId');
        debugPrint(
          '📅 [BookingTableCubit] Week: ${weekStart.toIso8601String()} to ${weekEnd.toIso8601String()}',
        );
        debugPrint(
          '📊 [BookingTableCubit] Total bookings in database: ${bookings.length}',
        );

        // Show all bookings for debugging
        for (final b in bookings) {
          debugPrint(
            '   📝 Booking: ${b.fieldName ?? b.fieldId} on ${b.date.toIso8601String()} at ${b.startTime} (Status: ${b.status.name})',
          );
        }

        // Filter bookings for this field and week
        // Compare only the date parts (ignore time)
        final filteredBookings = bookings.where((b) {
          final bookingDate = DateTime(b.date.year, b.date.month, b.date.day);
          final rangeStart = DateTime(
            weekStart.year,
            weekStart.month,
            weekStart.day,
          );
          final rangeEnd = DateTime(weekEnd.year, weekEnd.month, weekEnd.day);

          final matchesField = b.fieldId == fieldId;
          final inDateRange =
              !bookingDate.isBefore(rangeStart) &&
              bookingDate.isBefore(rangeEnd);

          if (matchesField && inDateRange) {
            debugPrint(
              '✅ [BookingTableCubit] Including booking: ${b.id} on ${b.date.toIso8601String()} at ${b.startTime}',
            );
          }

          return matchesField && inDateRange;
        });

        debugPrint(
          '✅ [BookingTableCubit] Bookings matching field + week: ${filteredBookings.length}',
        );

        if (filteredBookings.isEmpty) {
          debugPrint(
            '💡 [BookingTableCubit] No bookings found for this field in this week!',
          );
        }

        for (final booking in filteredBookings) {
          // Calculate day index (0 = Saturday)
          final dayIndex = _getDayIndex(booking.date, weekStart);
          if (dayIndex < 0 || dayIndex > 6) {
            debugPrint(
              '⚠️ [BookingTableCubit] Booking outside day range: dayIndex=$dayIndex',
            );
            continue;
          }

          // Normalize start and end times to HH:mm format
          final startTimeParts = booking.startTime.split(':');
          final endTimeParts = booking.endTime.split(':');

          final startHour = int.parse(startTimeParts[0]);
          final endHour = int.parse(endTimeParts[0]);

          // Calculate duration in hours
          final durationHours = endHour - startHour;

          // Map booking to all hour slots it occupies
          // For 1 hour: just start slot
          // For 2 hours: start slot + next slot
          for (int i = 0; i < durationHours; i++) {
            final hourSlot = startHour + i;
            final slotTime = '${hourSlot.toString().padLeft(2, '0')}:00';
            final slotKey = '${dayIndex}_$slotTime';

            slots[slotKey] = booking;

            debugPrint(
              '📍 [BookingTableCubit] Mapped booking to slot: $slotKey (${i + 1}/$durationHours hours)',
            );
          }
        }

        debugPrint(
          '🎯 [BookingTableCubit] Grid slots populated: ${slots.length}',
        );
        debugPrint(
          '🔍 [BookingTableCubit] ========================================',
        );

        return slots;
      },
    );
  }

  /// Get the Saturday start of the week containing the given date.
  DateTime _getWeekStart(DateTime date) {
    // In DateTime: Monday=1, Tuesday=2, ..., Saturday=6, Sunday=7
    // We want Saturday as first day (index 0)
    final dayOfWeek = date.weekday; // 1-7 (Mon-Sun)
    final daysFromSaturday = (dayOfWeek + 1) % 7; // Sat=0, Sun=1, Mon=2, ...
    return DateTime(date.year, date.month, date.day - daysFromSaturday);
  }

  /// Get day index (0-6) for a date relative to week start.
  int _getDayIndex(DateTime date, DateTime weekStart) {
    return date.difference(weekStart).inDays;
  }

  /// Navigate to booking details page.
  void navigateToBookingDetails(BookingEntity booking) {
    // Navigation will be handled by the UI using this trigger
    debugPrint('📱 Navigate to booking details: ${booking.id}');
  }

  /// Navigate to manual booking page with pre-filled data.
  void navigateToManualBooking({required int dayIndex, required String hour}) {
    final currentState = state;
    if (currentState is! BookingTableLoaded) return;

    // Navigation will be handled by the UI using this trigger
    debugPrint('📱 Navigate to manual booking: day=$dayIndex, hour=$hour');
  }
}
