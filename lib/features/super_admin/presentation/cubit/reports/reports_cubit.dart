import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/services/csv_export_service.dart';
import 'package:spo_kick/core/services/pdf_export_service.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_all_fields_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_admins_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_bookings_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_users_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_platform_statistics_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/reports/reports_state.dart';

/// Cubit for managing reports and data exports.
///
/// Handles:
/// - Loading all platform data for reports
/// - Exporting users/admins to CSV
/// - Exporting statistics to PDF
/// - Export progress and success states
class ReportsCubit extends Cubit<ReportsState> {
  final GetAllUsersUseCase _getAllUsersUseCase;
  final GetAllAdminsUseCase _getAllAdminsUseCase;
  final GetAllBookingsUseCase _getAllBookingsUseCase;
  final GetAllFieldsUseCase _getAllFieldsUseCase;
  final GetPlatformStatisticsUseCase _getPlatformStatisticsUseCase;
  final CsvExportService _csvExportService;
  final PdfExportService _pdfExportService;

  // Cached data for exports
  List<UserEntity> _users = [];
  List<UserEntity> _admins = [];
  List<BookingEntity> _bookings = [];
  List<FieldEntity> _fields = [];
  PlatformStatisticsEntity? _statistics;

  ReportsCubit({
    required GetAllUsersUseCase getAllUsersUseCase,
    required GetAllAdminsUseCase getAllAdminsUseCase,
    required GetAllBookingsUseCase getAllBookingsUseCase,
    required GetAllFieldsUseCase getAllFieldsUseCase,
    required GetPlatformStatisticsUseCase getPlatformStatisticsUseCase,
    required CsvExportService csvExportService,
    required PdfExportService pdfExportService,
  }) : _getAllUsersUseCase = getAllUsersUseCase,
       _getAllAdminsUseCase = getAllAdminsUseCase,
       _getAllBookingsUseCase = getAllBookingsUseCase,
       _getAllFieldsUseCase = getAllFieldsUseCase,
       _getPlatformStatisticsUseCase = getPlatformStatisticsUseCase,
       _csvExportService = csvExportService,
       _pdfExportService = pdfExportService,
       super(const ReportsInitial());

  /// Load all data needed for reports.
  Future<void> loadReportsData() async {
    debugPrint('🔄 [ReportsCubit] Loading reports data...');
    emit(const ReportsLoading(message: 'Loading platform data...'));

    try {
      // Load users
      final usersResult = await _getAllUsersUseCase();
      _users = usersResult.fold((l) => [], (r) => r);

      // Load admins
      final adminsResult = await _getAllAdminsUseCase();
      _admins = adminsResult.fold((l) => [], (r) => r);

      // Load bookings
      final bookingsResult = await _getAllBookingsUseCase();
      _bookings = bookingsResult.fold((l) => [], (r) => r);

      // Load fields
      final fieldsResult = await _getAllFieldsUseCase();
      _fields = fieldsResult.fold((l) => [], (r) => r);

      // Load statistics
      final statsResult = await _getPlatformStatisticsUseCase();
      _statistics = statsResult.fold((l) => null, (r) => r);

      debugPrint('✅ [ReportsCubit] Reports data loaded');
      debugPrint('   Users: ${_users.length}');
      debugPrint('   Admins: ${_admins.length}');
      debugPrint('   Bookings: ${_bookings.length}');
      debugPrint('   Fields: ${_fields.length}');

      emit(
        ReportsDataLoaded(
          users: _users,
          admins: _admins,
          bookings: _bookings,
          fields: _fields,
          statistics: _statistics,
        ),
      );
    } catch (e) {
      debugPrint('❌ [ReportsCubit] Error loading reports data: $e');
      emit(ReportsError('Failed to load reports data: $e'));
    }
  }

  /// Export users to CSV.
  Future<void> exportUsersToCSV() async {
    if (_users.isEmpty) {
      emit(const ReportsError('No user data to export'));
      _restoreLoadedState();
      return;
    }

    debugPrint('🔄 [ReportsCubit] Exporting ${_users.length} users to CSV');
    emit(const ReportsExporting(exportType: 'Users CSV'));

    try {
      await _csvExportService.exportUsersToCsv(
        _users,
        'users_report_${DateTime.now().millisecondsSinceEpoch}',
      );
      debugPrint('✅ [ReportsCubit] Users exported successfully');
      emit(const ReportsExportSuccess(message: 'Users exported to CSV'));
      _restoreLoadedState();
    } catch (e) {
      debugPrint('❌ [ReportsCubit] Error exporting users: $e');
      emit(ReportsError('Failed to export users: $e'));
      _restoreLoadedState();
    }
  }

  /// Export admins to CSV.
  Future<void> exportAdminsToCSV() async {
    if (_admins.isEmpty) {
      emit(const ReportsError('No admin data to export'));
      _restoreLoadedState();
      return;
    }

    debugPrint('🔄 [ReportsCubit] Exporting ${_admins.length} admins to CSV');
    emit(const ReportsExporting(exportType: 'Admins CSV'));

    try {
      await _csvExportService.exportUsersToCsv(
        _admins,
        'admins_report_${DateTime.now().millisecondsSinceEpoch}',
      );
      debugPrint('✅ [ReportsCubit] Admins exported successfully');
      emit(const ReportsExportSuccess(message: 'Admins exported to CSV'));
      _restoreLoadedState();
    } catch (e) {
      debugPrint('❌ [ReportsCubit] Error exporting admins: $e');
      emit(ReportsError('Failed to export admins: $e'));
      _restoreLoadedState();
    }
  }

  /// Export all data to CSV (combined users and admins).
  Future<void> exportAllDataToCSV() async {
    final allUsers = [..._users, ..._admins];
    if (allUsers.isEmpty) {
      emit(const ReportsError('No data to export'));
      _restoreLoadedState();
      return;
    }

    debugPrint('🔄 [ReportsCubit] Exporting all data to CSV');
    emit(const ReportsExporting(exportType: 'All Data CSV'));

    try {
      await _csvExportService.exportUsersToCsv(
        allUsers,
        'platform_report_${DateTime.now().millisecondsSinceEpoch}',
      );
      debugPrint('✅ [ReportsCubit] All data exported successfully');
      emit(
        const ReportsExportSuccess(message: 'Platform data exported to CSV'),
      );
      _restoreLoadedState();
    } catch (e) {
      debugPrint('❌ [ReportsCubit] Error exporting data: $e');
      emit(ReportsError('Failed to export data: $e'));
      _restoreLoadedState();
    }
  }

  /// Export platform statistics to PDF.
  Future<void> exportStatisticsToPDF() async {
    if (_statistics == null) {
      emit(const ReportsError('No statistics data to export'));
      _restoreLoadedState();
      return;
    }

    debugPrint('🔄 [ReportsCubit] Exporting statistics to PDF');
    emit(const ReportsExporting(exportType: 'Statistics PDF'));

    try {
      await _pdfExportService.exportPlatformStatisticsToPdf(_statistics!);
      debugPrint('✅ [ReportsCubit] Statistics exported successfully');
      emit(const ReportsExportSuccess(message: 'Statistics exported to PDF'));
      _restoreLoadedState();
    } catch (e) {
      debugPrint('❌ [ReportsCubit] Error exporting statistics: $e');
      emit(ReportsError('Failed to export statistics: $e'));
      _restoreLoadedState();
    }
  }

  /// Restore loaded state after export operation.
  void _restoreLoadedState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!isClosed) {
        emit(
          ReportsDataLoaded(
            users: _users,
            admins: _admins,
            bookings: _bookings,
            fields: _fields,
            statistics: _statistics,
          ),
        );
      }
    });
  }

  // Getters for report data
  int get totalUsers => _users.length;
  int get totalAdmins => _admins.length;
  int get totalBookings => _bookings.length;
  int get totalFields => _fields.length;
  PlatformStatisticsEntity? get statistics => _statistics;
}
