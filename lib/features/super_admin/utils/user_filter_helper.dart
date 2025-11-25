import 'package:flutter/material.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';

/// Helper class for filtering users list
class UserFilterHelper {
  static List<UserEntity> filterUsers(
    List<UserEntity> users, {
    String? searchQuery,
    String? statusFilter,
    DateTimeRange? dateRange,
  }) {
    var filtered = users;

    // Status filter
    if (statusFilter != null) {
      if (statusFilter == 'active') {
        filtered = filtered.where((user) => user.isActive).toList();
      } else if (statusFilter == 'inactive') {
        filtered = filtered.where((user) => !user.isActive).toList();
      }
    }

    // Search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((user) {
        final nameMatch = user.fullName?.toLowerCase().contains(query) ?? false;
        final emailMatch = user.email.toLowerCase().contains(query);
        final phoneMatch = user.phone?.toLowerCase().contains(query) ?? false;
        return nameMatch || emailMatch || phoneMatch;
      }).toList();
    }

    // Date range filter
    if (dateRange != null && filtered.isNotEmpty) {
      filtered = filtered.where((user) {
        return user.createdAt.isAfter(dateRange.start) &&
            user.createdAt.isBefore(dateRange.end);
      }).toList();
    }

    return filtered;
  }
}
