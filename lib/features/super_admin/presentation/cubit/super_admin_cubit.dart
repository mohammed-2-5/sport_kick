import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/services/csv_export_service.dart';
import 'package:spo_kick/core/services/pdf_export_service.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_all_fields_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/activate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/assign_field_to_admin_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_admin_account_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_field_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/deactivate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_active_cities_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_admins_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_bookings_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_users_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_platform_statistics_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';

import 'extensions/admin_management_operations.dart';
import 'extensions/booking_operations.dart';
import 'extensions/city_operations.dart';
import 'extensions/export_operations.dart';
import 'extensions/field_management_operations.dart';
import 'extensions/statistics_operations.dart';
import 'extensions/user_management_operations.dart';

// Export all extension methods so they're available to files that import this cubit
export 'extensions/admin_management_operations.dart';
export 'extensions/booking_operations.dart';
export 'extensions/city_operations.dart';
export 'extensions/export_operations.dart';
export 'extensions/field_management_operations.dart';
export 'extensions/statistics_operations.dart';
export 'extensions/user_management_operations.dart';

/// Cubit for managing super admin state.
///
/// Handles all super admin operations through mixins:
/// - Platform statistics (statistics_operations.dart)
/// - Admin management (admin_management_operations.dart)
/// - User management (user_management_operations.dart)
/// - Field management (field_management_operations.dart)
/// - City management (city_operations.dart)
/// - Booking management (booking_operations.dart)
/// - Data export (export_operations.dart)
///
/// All methods are organized into focused mixins for better maintainability.
class SuperAdminCubit extends Cubit<SuperAdminState>
    with
        AdminManagementOperations,
        BookingOperations,
        CityOperations,
        ExportOperations,
        FieldManagementOperations,
        StatisticsOperations,
        UserManagementOperations {
  // Use cases
  @override
  final GetPlatformStatisticsUseCase getPlatformStatisticsUseCase;
  @override
  final CreateAdminAccountUseCase createAdminAccountUseCase;
  @override
  final CreateFieldUseCase createFieldUseCase;
  @override
  final GetAllAdminsUseCase getAllAdminsUseCase;
  @override
  final GetAllUsersUseCase getAllUsersUseCase;
  @override
  final AssignFieldToAdminUseCase assignFieldToAdminUseCase;
  @override
  final GetActiveCitiesUseCase getActiveCitiesUseCase;
  @override
  final GetAllFieldsUseCase getAllFieldsUseCase;
  @override
  final GetAllBookingsUseCase getAllBookingsUseCase;
  @override
  final DeactivateUserUseCase deactivateUserUseCase;
  @override
  final ActivateUserUseCase activateUserUseCase;

  // Services
  @override
  final CsvExportService csvExportService;
  @override
  final PdfExportService pdfExportService;

  SuperAdminCubit({
    required this.getPlatformStatisticsUseCase,
    required this.createAdminAccountUseCase,
    required this.createFieldUseCase,
    required this.getAllAdminsUseCase,
    required this.getAllUsersUseCase,
    required this.assignFieldToAdminUseCase,
    required this.getActiveCitiesUseCase,
    required this.getAllFieldsUseCase,
    required this.getAllBookingsUseCase,
    required this.deactivateUserUseCase,
    required this.activateUserUseCase,
    required this.csvExportService,
    required this.pdfExportService,
  }) : super(const SuperAdminInitial());

  /// Reset to initial state.
  void reset() {
    debugPrint('🔄 [SuperAdminCubit] Resetting state');
    emit(const SuperAdminInitial());
  }
}
