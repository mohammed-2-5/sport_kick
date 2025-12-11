import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Mobile/Desktop implementation for PDF export.
Future<void> exportPdf(Uint8List bytes, String fileName) async {
  // Save to file
  final directory = await getTemporaryDirectory();
  final file = File('${directory.path}/$fileName');
  await file.writeAsBytes(bytes);

  // Share file
  // ignore: deprecated_member_use
  await Share.shareXFiles([
    XFile(file.path),
  ], subject: 'Sport Kick Analytics Report');
}
