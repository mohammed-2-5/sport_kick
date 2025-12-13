import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Helper class for platform-specific file export operations.
///
/// Provides common functionality for both mobile and desktop platforms
/// to save files and share them via the native share sheet.
class PlatformExportHelper {
  /// Save bytes to a temporary file and share it.
  ///
  /// Used for binary files like PDFs.
  static Future<void> shareBytes({
    required Uint8List bytes,
    required String fileName,
    required String subject,
  }) async {
    // Save to temporary directory
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);

    // Share file via native share sheet
    // ignore: deprecated_member_use
    await Share.shareXFiles([XFile(file.path)], subject: subject);
  }

  /// Save string content to a temporary file and share it.
  ///
  /// Used for text files like CSV.
  static Future<void> shareString({
    required String content,
    required String fileName,
    required String subject,
  }) async {
    // Save to temporary directory
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(content);

    // Share file via native share sheet
    // ignore: deprecated_member_use
    await Share.shareXFiles([XFile(file.path)], subject: subject);
  }
}
