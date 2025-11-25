import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:spo_kick/core/network/api_client.dart';
import 'package:spo_kick/core/network/network_info.dart';
import 'package:spo_kick/core/services/csv_export_service.dart';
import 'package:spo_kick/core/services/pdf_export_service.dart';

// Auth Feature
import 'package:spo_kick/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:spo_kick/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:spo_kick/features/auth/domain/repositories/auth_repository.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/login_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/logout_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/register_usecase.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';

// Fields Feature
import 'package:spo_kick/features/fields/data/datasources/field_remote_datasource.dart';
import 'package:spo_kick/features/fields/data/repositories/field_repository_impl.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_all_fields_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_field_by_id_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_fields_by_category_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_featured_fields_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_sport_categories_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/search_fields_usecase.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';

// Bookings Feature
import 'package:spo_kick/features/bookings/data/datasources/booking_remote_datasource.dart';
import 'package:spo_kick/features/bookings/data/repositories/booking_repository_impl.dart';
import 'package:spo_kick/features/bookings/domain/repositories/booking_repository.dart';
import 'package:spo_kick/features/bookings/domain/usecases/cancel_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/create_manual_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_available_time_slots_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_booking_by_id_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_owner_bookings_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_user_bookings_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/update_booking_status_usecase.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';

// Super Admin Feature
import 'package:spo_kick/features/super_admin/data/datasources/super_admin_remote_datasource.dart';
import 'package:spo_kick/features/super_admin/data/repositories/super_admin_repository_impl.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';
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
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';

/// Service Locator instance.
///
/// This is a global instance of GetIt used for dependency injection
/// throughout the app.
///
/// Usage:
/// ```dart
/// final authCubit = sl<AuthCubit>();
/// ```
final sl = GetIt.instance;

/// Initialize all dependencies.
///
/// This should be called once at app startup, before runApp().
/// Dependencies are registered in order of their dependencies.
///
/// Example:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await initDependencies();
///   runApp(MyApp());
/// }
/// ```
Future<void> initDependencies() async {
  // ==================== EXTERNAL DEPENDENCIES ====================
  await _initExternal();

  // ==================== CORE ====================
  await _initCore();

  // ==================== FEATURES ====================
  // Auth Feature
  _initAuth();

  // Fields Feature
  _initFields();

  // Bookings Feature
  _initBookings();

  // Super Admin Feature
  _initSuperAdmin();

  // Reviews Feature
  // TODO: Initialize reviews dependencies
  // _initReviews();
}

/// Initialize external dependencies.
///
/// These are third-party packages and services that the app depends on.
Future<void> _initExternal() async {
  // Supabase Client
  final supabaseClient = Supabase.instance.client;
  sl.registerLazySingleton<SupabaseClient>(() => supabaseClient);

  // Dio HTTP Client
  final dio = Dio();
  sl.registerLazySingleton<Dio>(() => dio);

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Connectivity
  final connectivity = Connectivity();
  sl.registerLazySingleton<Connectivity>(() => connectivity);

  // Hive (Local Database)
  // Note: Hive.initFlutter() should be called in main()
  // Here we just register the box accessors
  // Example:
  // final userBox = await Hive.openBox('user_box');
  // sl.registerLazySingleton<Box>(() => userBox, instanceName: 'userBox');
}

/// Initialize core dependencies.
///
/// These are app-level utilities and services used across features.
Future<void> _initCore() async {
  // Network Info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );

  // API Client
  sl.registerLazySingleton<ApiClient>(() => ApiClient(dio: sl()));

  // CSV Export Service
  sl.registerLazySingleton<CsvExportService>(() => CsvExportService());

  // PDF Export Service
  sl.registerLazySingleton<PdfExportService>(() => PdfExportService());
}

// ==================== FEATURE: AUTH ====================

/// Initialize authentication feature dependencies.
///
/// Dependencies hierarchy:
/// - Cubits (Factory) depend on UseCases
/// - UseCases (LazySingleton) depend on Repositories
/// - Repositories (LazySingleton) depend on Data Sources
/// - Data Sources (LazySingleton) depend on External services
void _initAuth() {
  // Cubits
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabase: sl()),
  );
}

// ==================== FEATURE: FIELDS ====================

/// Initialize fields feature dependencies.
///
/// Dependencies hierarchy:
/// - Cubits (Factory) depend on UseCases
/// - UseCases (LazySingleton) depend on Repositories
/// - Repositories (LazySingleton) depend on Data Sources
/// - Data Sources (LazySingleton) depend on External services
void _initFields() {
  // Cubits
  sl.registerFactory(
    () => FieldsCubit(
      getAllFieldsUseCase: sl(),
      getFieldByIdUseCase: sl(),
      getFieldsByCategoryUseCase: sl(),
      getFeaturedFieldsUseCase: sl(),
      getSportCategoriesUseCase: sl(),
      searchFieldsUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetAllFieldsUseCase(sl()));
  sl.registerLazySingleton(() => GetFieldByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetFieldsByCategoryUseCase(sl()));
  sl.registerLazySingleton(() => GetFeaturedFieldsUseCase(sl()));
  sl.registerLazySingleton(() => GetSportCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => SearchFieldsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<FieldRepository>(() => FieldRepositoryImpl(sl()));

  // Data Sources
  sl.registerLazySingleton<FieldRemoteDataSource>(
    () => FieldRemoteDataSourceImpl(sl()),
  );
}

// ==================== FEATURE: BOOKINGS ====================

/// Initialize bookings feature dependencies.
///
/// Dependencies hierarchy:
/// - Cubits (Factory) depend on UseCases
/// - UseCases (LazySingleton) depend on Repositories
/// - Repositories (LazySingleton) depend on Data Sources
/// - Data Sources (LazySingleton) depend on External services
void _initBookings() {
  // Cubits
  sl.registerFactory(
    () => BookingCubit(
      getAvailableTimeSlotsUseCase: sl(),
      createBookingUseCase: sl(),
      createManualBookingUseCase: sl(),
      getUserBookingsUseCase: sl(),
      getBookingByIdUseCase: sl(),
      cancelBookingUseCase: sl(),
      getOwnerBookingsUseCase: sl(),
      updateBookingStatusUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetAvailableTimeSlotsUseCase(sl()));
  sl.registerLazySingleton(() => CreateBookingUseCase(sl()));
  sl.registerLazySingleton(() => CreateManualBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetUserBookingsUseCase(sl()));
  sl.registerLazySingleton(() => GetBookingByIdUseCase(sl()));
  sl.registerLazySingleton(() => CancelBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetOwnerBookingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateBookingStatusUseCase(sl()));

  // Repository
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(supabaseClient: sl()),
  );
}

// ==================== FEATURE: SUPER ADMIN ====================

/// Initialize super admin feature dependencies.
///
/// Dependencies hierarchy:
/// - Cubits (Factory) depend on UseCases
/// - UseCases (LazySingleton) depend on Repositories
/// - Repositories (LazySingleton) depend on Data Sources
/// - Data Sources (LazySingleton) depend on External services
void _initSuperAdmin() {
  // Cubits
  sl.registerFactory(
    () => SuperAdminCubit(
      getPlatformStatisticsUseCase: sl(),
      createAdminAccountUseCase: sl(),
      createFieldUseCase: sl(),
      getAllAdminsUseCase: sl(),
      getAllUsersUseCase: sl(),
      assignFieldToAdminUseCase: sl(),
      getActiveCitiesUseCase: sl(),
      getAllFieldsUseCase: sl(),
      getAllBookingsUseCase: sl(),
      deactivateUserUseCase: sl(),
      activateUserUseCase: sl(),
      csvExportService: sl(),
      pdfExportService: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetPlatformStatisticsUseCase(sl()));
  sl.registerLazySingleton(() => CreateAdminAccountUseCase(sl()));
  sl.registerLazySingleton(() => CreateFieldUseCase(sl()));
  sl.registerLazySingleton(() => GetAllAdminsUseCase(sl()));
  sl.registerLazySingleton(() => GetAllUsersUseCase(sl()));
  sl.registerLazySingleton(() => AssignFieldToAdminUseCase(sl()));
  sl.registerLazySingleton(() => GetActiveCitiesUseCase(sl()));
  sl.registerLazySingleton(() => GetAllBookingsUseCase(sl()));
  sl.registerLazySingleton(() => DeactivateUserUseCase(sl()));
  sl.registerLazySingleton(() => ActivateUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<SuperAdminRepository>(
    () => SuperAdminRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<SuperAdminRemoteDataSource>(
    () => SuperAdminRemoteDataSourceImpl(supabaseClient: sl()),
  );
}

// ==================== FEATURE: REVIEWS ====================

/// Initialize reviews feature dependencies.
///
/// Call this when implementing the reviews feature.
///
/// Example:
/// ```dart
/// void _initReviews() {
///   // Cubits
///   sl.registerFactory(
///     () => ReviewsCubit(
///       getFieldReviewsUseCase: sl(),
///       addReviewUseCase: sl(),
///     ),
///   );
///
///   // Use Cases
///   sl.registerLazySingleton(() => GetFieldReviewsUseCase(sl()));
///   sl.registerLazySingleton(() => AddReviewUseCase(sl()));
///
///   // Repository
///   sl.registerLazySingleton<ReviewRepository>(
///     () => ReviewRepositoryImpl(
///       remoteDataSource: sl(),
///       networkInfo: sl(),
///     ),
///   );
///
///   // Data Sources
///   sl.registerLazySingleton<ReviewRemoteDataSource>(
///     () => ReviewRemoteDataSourceImpl(supabaseClient: sl()),
///   );
/// }
/// ```

/// Reset all dependencies (useful for testing).
///
/// This will unregister all dependencies and clear the service locator.
/// Should only be used in tests.
///
/// Example:
/// ```dart
/// setUp(() async {
///   await resetDependencies();
///   await initDependencies();
/// });
/// ```
Future<void> resetDependencies() async {
  await sl.reset();
}

/// Check if a dependency is registered.
///
/// Useful for debugging dependency issues.
///
/// Example:
/// ```dart
/// if (isDependencyRegistered<AuthCubit>()) {
///   print('AuthCubit is registered');
/// }
/// ```
bool isDependencyRegistered<T extends Object>() {
  return sl.isRegistered<T>();
}

/// Get debug information about registered dependencies.
///
/// Useful for debugging dependency issues.
/// Returns a string with information about the service locator state.
String getRegistrationDebugInfo() {
  return '''
GetIt Registration Info:
- Has registrations: ${sl.allReadySync()}
- Ready count: ${sl.allReadySync() ? 'All ready' : 'Not all ready'}

To check if a specific type is registered, use:
isDependencyRegistered<YourType>()
  ''';
}
