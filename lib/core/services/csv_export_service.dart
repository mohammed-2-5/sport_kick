import 'dart:io';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';

/// Service for exporting data to CSV files
class CsvExportService {
  /// Export a list of users to a CSV file and share it
  Future<void> exportUsersToCsv(List<UserEntity> users, String fileName) async {
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

    // Save to file
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName.csv');
    await file.writeAsString(csv);

    // Share file
    await Share.shareXFiles([XFile(file.path)], text: 'Exported $fileName CSV');
  }
}
