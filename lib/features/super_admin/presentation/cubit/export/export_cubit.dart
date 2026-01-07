import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/services/csv_export_service.dart';
import 'package:spo_kick/core/services/pdf_export_service.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/export/export_state.dart';

/// Cubit for data export operations.
///
/// Handles exporting data to CSV and PDF formats for reporting.
class ExportCubit extends Cubit<ExportState> {
  final CsvExportService csvExportService;
  final PdfExportService pdfExportService;

  ExportCubit({required this.csvExportService, required this.pdfExportService})
    : super(const ExportInitial());

  /// Export users to CSV file.
  Future<void> exportUsersToCSV(List<UserEntity> users) async {
    debugPrint('🔄 [ExportCubit] Exporting ${users.length} users to CSV');

    try {
      await csvExportService.exportUsersToCsv(
        users,
        'users_export_${DateTime.now().millisecondsSinceEpoch}',
      );
      debugPrint('✅ [ExportCubit] Users exported successfully');
      emit(const ExportSuccess('Users exported successfully'));
    } catch (e) {
      debugPrint('❌ [ExportCubit] Error exporting users: $e');
      emit(ExportError('Failed to export users: $e'));
    }
  }

  /// Export admins to CSV file.
  Future<void> exportAdminsToCSV(List<UserEntity> admins) async {
    debugPrint('🔄 [ExportCubit] Exporting ${admins.length} admins to CSV');

    try {
      await csvExportService.exportUsersToCsv(
        admins,
        'admins_export_${DateTime.now().millisecondsSinceEpoch}',
      );
      debugPrint('✅ [ExportCubit] Admins exported successfully');
      emit(const ExportSuccess('Admins exported successfully'));
    } catch (e) {
      debugPrint('❌ [ExportCubit] Error exporting admins: $e');
      emit(ExportError('Failed to export admins: $e'));
    }
  }

  /// Export platform statistics to PDF report
  Future<void> exportPlatformStatisticsToPDF(
    PlatformStatisticsEntity stats,
  ) async {
    debugPrint('🔄 [ExportCubit] Exporting platform statistics to PDF');

    try {
      await pdfExportService.exportPlatformStatisticsToPdf(stats);
      debugPrint('✅ [ExportCubit] Platform statistics exported');
      emit(const ExportSuccess('Statistics exported successfully'));
    } catch (e) {
      debugPrint('❌ [ExportCubit] Error exporting statistics: $e');
      emit(ExportError('Failed to export statistics: $e'));
    }
  }

  /// Reset to initial state.
  void reset() {
    emit(const ExportInitial());
  }
}
