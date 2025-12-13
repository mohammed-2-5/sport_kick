// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:typed_data';

/// Helper class for web-specific file export operations.
///
/// Provides common functionality for web platforms to trigger
/// browser downloads of files.
class WebExportHelper {
  /// Trigger browser download for binary data.
  ///
  /// Creates a blob, generates a download link, and triggers the download.
  static Future<void> downloadBytes({
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
  }) async {
    // Create blob
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create download link
    final anchor = html.AnchorElement()
      ..href = url
      ..download = fileName
      ..style.display = 'none';

    // Trigger download
    html.document.body?.append(anchor);
    anchor.click();

    // Cleanup
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  /// Trigger browser download for text data.
  ///
  /// Encodes text as UTF-8 with BOM and triggers download.
  static Future<void> downloadText({
    required List<int> bytes,
    required String fileName,
    required String mimeType,
  }) async {
    // Create blob
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create download link
    final anchor = html.AnchorElement()
      ..href = url
      ..download = fileName
      ..style.display = 'none';

    // Trigger download
    html.document.body?.append(anchor);
    anchor.click();

    // Cleanup
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}
