import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Mobile/Desktop implementation for CSV export.
/// Uses file system and native share sheet.
Future<void> exportCsv(String csv, String fileName) async {
  // Save to file
  final directory = await getTemporaryDirectory();
  final file = File('${directory.path}/$fileName');
  await file.writeAsString(csv);

  // Share file
  // ignore: deprecated_member_use
  await Share.shareXFiles([XFile(file.path)], subject: 'Exported $fileName');
}
