import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';

// Conditional imports for web/mobile
import 'csv_export_service_stub.dart'
    if (dart.library.io) 'csv_export_service_mobile.dart'
    if (dart.library.html) 'csv_export_service_web.dart'
    as platform;

/// Service for exporting data to CSV files.
///
/// Automatically uses platform-specific implementation:
/// - Mobile/Desktop: Uses file system and share sheet
/// - Web: Uses browser download
class CsvExportService {
  /// Export a list of users to a CSV file.
  Future<void> exportUsersToCsv(List<UserEntity> users, String fileName) async {
    debugPrint('📊 [CsvExportService] Exporting ${users.length} users to CSV');

    final List<List<dynamic>> rows = [];

    // Add header row
    rows.add([
      'ID',
      'Full Name',
      'Email',
      'Phone',
      'Role',
      'Status',
      'Joined Date',
    ]);

    // Add user data rows
    for (final user in users) {
      rows.add([
        user.id,
        user.fullName ?? 'N/A',
        user.email,
        user.phone ?? 'N/A',
        user.role,
        user.isActive ? 'Active' : 'Inactive',
        DateFormat('yyyy-MM-dd HH:mm').format(user.createdAt),
      ]);
    }

    // Convert to CSV string
    final String csv = const ListToCsvConverter().convert(rows);

    // Use platform-specific export
    await platform.exportCsv(csv, '$fileName.csv');

    debugPrint('✅ [CsvExportService] CSV export completed');
  }
}
