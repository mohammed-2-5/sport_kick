import 'package:spo_kick/core/services/platform_export_helper.dart';

/// Mobile/Desktop implementation for CSV export.
/// Uses file system and native share sheet.
Future<void> exportCsv(String csv, String fileName) async {
  await PlatformExportHelper.shareString(
    content: csv,
    fileName: fileName,
    subject: 'Exported $fileName',
  );
}
