import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:intl/intl.dart';

/// State for the booking table screen.
sealed class BookingTableState extends Equatable {
  const BookingTableState();

  @override
  List<Object?> get props => [];
}

/// Initial state when screen first loads.
class BookingTableInitial extends BookingTableState {
  const BookingTableInitial();
}

/// Loading state while fetching data.
class BookingTableLoading extends BookingTableState {
  final String? message;
  const BookingTableLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// State when bookings are loaded and ready to display.
class BookingTableLoaded extends BookingTableState {
  /// The currently selected field.
  final FieldEntity selectedField;

  /// All owner's fields for dropdown.
  final List<FieldEntity> ownerFields;

  /// The week start date (Saturday).
  final DateTime weekStartDate;

  /// Business hours for the selected field.
  final List<BusinessHoursEntity> businessHours;

  /// Bookings mapped to grid slots.
  /// Key: "day_hour" (e.g., "0_09:00"), Value: booking or null.
  final Map<String, BookingEntity?> bookingSlots;

  /// Whether currently refreshing.
  final bool isRefreshing;

  const BookingTableLoaded({
    required this.selectedField,
    required this.ownerFields,
    required this.weekStartDate,
    required this.businessHours,
    required this.bookingSlots,
    this.isRefreshing = false,
  });

  /// Get week end date (Friday).
  DateTime get weekEndDate => weekStartDate.add(const Duration(days: 6));

  /// Get formatted week range string.
  String get weekRangeString {
    final locale = Intl.getCurrentLocale();
    final startPattern = weekStartDate.year == weekEndDate.year
        ? 'MMM d'
        : 'MMM d, y';
    final startLabel = DateFormat(startPattern, locale).format(weekStartDate);
    final endLabel = DateFormat('MMM d, y', locale).format(weekEndDate);

    return '$startLabel - $endLabel';
  }

  /// Check if current week contains today.
  bool get isCurrentWeek {
    final today = DateTime.now();
    return today.isAfter(weekStartDate.subtract(const Duration(days: 1))) &&
        today.isBefore(weekEndDate.add(const Duration(days: 1)));
  }

  /// Get business hours for a specific day.
  BusinessHoursEntity? getBusinessHoursForDay(int dayIndex) {
    // dayIndex: 0=Sat, 1=Sun, 2=Mon, 3=Tue, 4=Wed, 5=Thu, 6=Fri
    // BusinessHours dayOfWeek: 0=Saturday, 1=Sunday, ...
    try {
      return businessHours.firstWhere((h) => h.dayOfWeek == dayIndex);
    } catch (_) {
      return null;
    }
  }

  /// Get booking for a specific slot.
  BookingEntity? getBookingAt(int dayIndex, String hour) {
    final key = '${dayIndex}_$hour';
    return bookingSlots[key];
  }

  /// Copy with method for updates.
  BookingTableLoaded copyWith({
    FieldEntity? selectedField,
    List<FieldEntity>? ownerFields,
    DateTime? weekStartDate,
    List<BusinessHoursEntity>? businessHours,
    Map<String, BookingEntity?>? bookingSlots,
    bool? isRefreshing,
  }) {
    return BookingTableLoaded(
      selectedField: selectedField ?? this.selectedField,
      ownerFields: ownerFields ?? this.ownerFields,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      businessHours: businessHours ?? this.businessHours,
      bookingSlots: bookingSlots ?? this.bookingSlots,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    selectedField,
    ownerFields,
    weekStartDate,
    businessHours,
    bookingSlots,
    isRefreshing,
  ];
}

/// Error state when something goes wrong.
class BookingTableError extends BookingTableState {
  final String message;
  const BookingTableError(this.message);

  @override
  List<Object?> get props => [message];
}
