import 'dart:typed_data';

import 'package:spo_kick/core/services/platform_export_helper.dart';

/// Mobile/Desktop implementation for PDF export.
Future<void> exportPdf(Uint8List bytes, String fileName) async {
  await PlatformExportHelper.shareBytes(
    bytes: bytes,
    fileName: fileName,
    subject: 'Sport Kick Analytics Report',
  );
}
