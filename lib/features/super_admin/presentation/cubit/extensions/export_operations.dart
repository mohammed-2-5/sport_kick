import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/services/csv_export_service.dart';
import 'package:spo_kick/core/services/pdf_export_service.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';

/// Mixin for data export operations.
///
/// Handles exporting data to CSV and PDF formats for reporting.
mixin ExportOperations on Cubit<SuperAdminState> {
  // Dependencies
  CsvExportService get csvExportService;
  PdfExportService get pdfExportService;

  /// Export users to CSV file.
  Future<void> exportUsersToCSV(List<UserEntity> users) async {
    debugPrint('🔄 [SuperAdminCubit] Exporting ${users.length} users to CSV');

    try {
      await csvExportService.exportUsersToCsv(
        users,
        'users_export_${DateTime.now().millisecondsSinceEpoch}',
      );
      debugPrint('✅ [SuperAdminCubit] Users exported successfully');
    } catch (e) {
      debugPrint('❌ [SuperAdminCubit] Error exporting users: $e');
      emit(SuperAdminError('Failed to export users: $e'));
    }
  }

  /// Export admins to CSV file.
  Future<void> exportAdminsToCSV(List<UserEntity> admins) async {
    debugPrint('🔄 [SuperAdminCubit] Exporting ${admins.length} admins to CSV');

    try {
      await csvExportService.exportUsersToCsv(
        admins,
        'admins_export_${DateTime.now().millisecondsSinceEpoch}',
      );
      debugPrint('✅ [SuperAdminCubit] Admins exported successfully');
    } catch (e) {
      debugPrint('❌ [SuperAdminCubit] Error exporting admins: $e');
      emit(SuperAdminError('Failed to export admins: $e'));
    }
  }

  /// Export platform statistics to PDF report
  Future<void> exportPlatformStatisticsToPDF(
    PlatformStatisticsEntity stats,
  ) async {
    debugPrint('🔄 [SuperAdminCubit] Exporting platform statistics to PDF');

    try {
      await pdfExportService.exportPlatformStatisticsToPdf(stats);
      debugPrint('✅ [SuperAdminCubit] Platform statistics exported');
    } catch (e) {
      debugPrint('❌ [SuperAdminCubit] Error exporting statistics: $e');
      emit(SuperAdminError('Failed to export statistics: $e'));
    }
  }
}
