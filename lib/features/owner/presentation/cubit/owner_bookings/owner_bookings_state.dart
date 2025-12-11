import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';

/// State for owner bookings management.
///
/// Manages:
/// - Bookings list
/// - Filter/tab selection
/// - Search query
/// - Sort options
sealed class OwnerBookingsState extends Equatable {
  const OwnerBookingsState();

  @override
  List<Object?> get props => [];
}

/// Initial loading state.
final class OwnerBookingsLoading extends OwnerBookingsState {
  const OwnerBookingsLoading();
}

/// Bookings loaded successfully.
final class OwnerBookingsLoaded extends OwnerBookingsState {
  final List<BookingEntity> allBookings;
  final BookingStatus? selectedFilter;
  final String searchQuery;
  final int selectedTabIndex;
  final bool isRefreshing;

  const OwnerBookingsLoaded({
    required this.allBookings,
    this.selectedFilter,
    this.searchQuery = '',
    this.selectedTabIndex = 0,
    this.isRefreshing = false,
  });

  /// Get filtered bookings based on current filter.
  List<BookingEntity> get filteredBookings {
    var bookings = allBookings;

    // Apply status filter
    if (selectedFilter != null) {
      bookings = bookings.where((b) => b.status == selectedFilter).toList();
    }

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      bookings = bookings.where((b) {
        return (b.fieldName?.toLowerCase().contains(query) ?? false) ||
            (b.userName?.toLowerCase().contains(query) ?? false) ||
            b.id.toLowerCase().contains(query);
      }).toList();
    }

    return bookings;
  }

  /// Get bookings count by status.
  int getCountByStatus(BookingStatus? status) {
    if (status == null) return allBookings.length;
    return allBookings.where((b) => b.status == status).length;
  }

  OwnerBookingsLoaded copyWith({
    List<BookingEntity>? allBookings,
    BookingStatus? selectedFilter,
    bool clearFilter = false,
    String? searchQuery,
    int? selectedTabIndex,
    bool? isRefreshing,
  }) {
    return OwnerBookingsLoaded(
      allBookings: allBookings ?? this.allBookings,
      selectedFilter: clearFilter
          ? null
          : (selectedFilter ?? this.selectedFilter),
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    allBookings,
    selectedFilter,
    searchQuery,
    selectedTabIndex,
    isRefreshing,
  ];
}

/// Error state.
final class OwnerBookingsError extends OwnerBookingsState {
  final String message;

  const OwnerBookingsError(this.message);

  @override
  List<Object?> get props => [message];
}
