import 'package:flutter/material.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';

/// Helper class for filtering admins list
class AdminFilterHelper {
  static List<UserEntity> filterAdmins(
    List<UserEntity> admins, {
    String? searchQuery,
    String? statusFilter,
    DateTimeRange? dateRange,
  }) {
    var filtered = admins;

    // Search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((admin) {
        final nameMatch =
            admin.fullName?.toLowerCase().contains(query) ?? false;
        final emailMatch = admin.email.toLowerCase().contains(query);
        final phoneMatch = admin.phone?.toLowerCase().contains(query) ?? false;
        return nameMatch || emailMatch || phoneMatch;
      }).toList();
    }

    // Status filter
    if (statusFilter != null) {
      filtered = filtered.where((admin) {
        if (statusFilter == 'active') return admin.isActive;
        if (statusFilter == 'inactive') return !admin.isActive;
        return true;
      }).toList();
    }

    // Date range filter
    if (dateRange != null && filtered.isNotEmpty) {
      filtered = filtered.where((admin) {
        if (admin.createdAt == null) return false;
        return admin.createdAt!.isAfter(dateRange.start) &&
            admin.createdAt!.isBefore(dateRange.end);
      }).toList();
    }

    return filtered;
  }
}
