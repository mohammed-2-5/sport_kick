// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:convert';

/// Web implementation for CSV export.
/// Uses browser download functionality.
Future<void> exportCsv(String csv, String fileName) async {
  // Create a blob with UTF-8 BOM for proper Excel encoding
  final bytes = utf8.encode('\uFEFF$csv');
  final blob = html.Blob([bytes], 'text/csv;charset=utf-8');

  // Create download link
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement()
    ..href = url
    ..download = fileName
    ..style.display = 'none';

  // Add to document, click, and remove
  html.document.body?.append(anchor);
  anchor.click();

  // Cleanup
  html.document.body?.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}
