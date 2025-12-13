import 'dart:typed_data';

import 'package:spo_kick/core/services/web_export_helper.dart';

/// Web implementation for PDF export.
Future<void> exportPdf(Uint8List bytes, String fileName) async {
  await WebExportHelper.downloadBytes(
    bytes: bytes,
    fileName: fileName,
    mimeType: 'application/pdf',
  );
}
