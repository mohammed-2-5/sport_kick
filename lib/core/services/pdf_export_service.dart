import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';

// Conditional imports for web/mobile
import 'pdf_export_service_stub.dart'
    if (dart.library.io) 'pdf_export_service_mobile.dart'
    if (dart.library.html) 'pdf_export_service_web.dart'
    as platform;

/// Service for exporting data to PDF files
class PdfExportService {
  /// Export platform statistics to a PDF report
  Future<void> exportPlatformStatisticsToPdf(
    PlatformStatisticsEntity stats,
  ) async {
    final pdf = pw.Document();

    // Add title page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Text(
                'Sport Kick Platform Analytics',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Generated: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey),
              ),
              pw.SizedBox(height: 32),

              // Overview Statistics
              pw.Text(
                'Platform Overview',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),

              _buildStatRow('Total Users', stats.totalUsers.toString()),
              _buildStatRow(
                'New Users (30 days)',
                stats.newUsersThisMonth.toString(),
              ),
              _buildStatRow('Total Admins', stats.totalAdmins.toString()),
              pw.SizedBox(height: 16),

              _buildStatRow('Total Fields', stats.totalFields.toString()),
              _buildStatRow('Active Fields', stats.activeFields.toString()),
              _buildStatRow('Total Bookings', stats.totalBookings.toString()),
              _buildStatRow('Pending', stats.pendingBookings.toString()),
              _buildStatRow('Confirmed', stats.confirmedBookings.toString()),
              _buildStatRow('Completed', stats.completedBookings.toString()),
              pw.SizedBox(height: 16),

              _buildStatRow(
                'Total Revenue',
                'EGP ${stats.totalRevenue.toStringAsFixed(2)}',
              ),
              _buildStatRow(
                'Revenue (30 days)',
                'EGP ${stats.revenueThisMonth.toStringAsFixed(2)}',
              ),
            ],
          );
        },
      ),
    );

    // Save and export using platform-specific implementation
    final bytes = await pdf.save();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'analytics_report_$timestamp.pdf';

    await platform.exportPdf(bytes, fileName);
  }

  /// Build a statistics row for PDF
  pw.Widget _buildStatRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 14)),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
