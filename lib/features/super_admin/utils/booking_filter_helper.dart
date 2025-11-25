import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';

/// Helper class for filtering bookings list
class BookingFilterHelper {
  /// Filters bookings based on search query and filter criteria
  static List<BookingEntity> filterBookings(
    List<BookingEntity> bookings, {
    String? searchQuery,
    BookingStatus? statusFilter,
    DateTimeRange? dateRange,
    String? fieldFilter,
    String? cityFilter,
  }) {
    var filtered = bookings;

    // Search filter - search by booking ID, customer name, field name
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((booking) {
        final idMatch = booking.id.toLowerCase().contains(query);
        final userNameMatch =
            booking.userName?.toLowerCase().contains(query) ?? false;
        final fieldNameMatch =
            booking.fieldName?.toLowerCase().contains(query) ?? false;
        return idMatch || userNameMatch || fieldNameMatch;
      }).toList();
    }

    // Status filter
    if (statusFilter != null) {
      filtered =
          filtered.where((booking) => booking.status == statusFilter).toList();
    }

    // Date range filter
    if (dateRange != null) {
      filtered = filtered.where((booking) {
        return booking.date.isAfter(dateRange.start) &&
            booking.date.isBefore(dateRange.end.add(const Duration(days: 1)));
      }).toList();
    }

    // Field filter
    if (fieldFilter != null && fieldFilter != 'all') {
      filtered = filtered
          .where((booking) => booking.fieldName == fieldFilter)
          .toList();
    }

    // City filter (if we add city to booking entity in the future)
    if (cityFilter != null && cityFilter != 'all') {
      // Note: This would require adding city field to BookingEntity
      // or joining with field data
      // For now, we'll leave this for future implementation
    }

    return filtered;
  }

  /// Get unique field names from bookings list
  static List<String> getUniqueFieldNames(List<BookingEntity> bookings) {
    return bookings
        .where((b) => b.fieldName != null)
        .map((b) => b.fieldName!)
        .toSet()
        .toList()
      ..sort();
  }

  /// Calculate booking statistics
  static ({
    int total,
    int pending,
    int confirmed,
    int canceled,
    int completed,
    double revenue,
  }) calculateStatistics(List<BookingEntity> bookings) {
    final total = bookings.length;
    final pending =
        bookings.where((b) => b.status == BookingStatus.pending).length;
    final confirmed =
        bookings.where((b) => b.status == BookingStatus.confirmed).length;
    final canceled =
        bookings.where((b) => b.status == BookingStatus.canceled).length;
    final completed =
        bookings.where((b) => b.status == BookingStatus.completed).length;
    final revenue = bookings
        .where(
          (b) =>
              b.status == BookingStatus.confirmed ||
              b.status == BookingStatus.completed,
        )
        .fold<double>(0, (sum, booking) => sum + booking.totalPrice);

    return (
      total: total,
      pending: pending,
      confirmed: confirmed,
      canceled: canceled,
      completed: completed,
      revenue: revenue,
    );
  }
}
