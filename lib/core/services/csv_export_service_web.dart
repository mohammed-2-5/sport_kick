import 'dart:convert';

import 'package:spo_kick/core/services/web_export_helper.dart';

/// Web implementation for CSV export.
/// Uses browser download functionality.
Future<void> exportCsv(String csv, String fileName) async {
  // Create bytes with UTF-8 BOM for proper Excel encoding
  final bytes = utf8.encode('\uFEFF$csv');

  await WebExportHelper.downloadText(
    bytes: bytes,
    fileName: fileName,
    mimeType: 'text/csv;charset=utf-8',
  );
}
