// Core and external dependencies
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:spo_kick/core/network/network_info.dart';
import 'package:spo_kick/core/services/csv_export_service.dart';
import 'package:spo_kick/core/services/error_logging_service.dart';
import 'package:spo_kick/core/services/pdf_export_service.dart';

// Auth Feature
import 'package:spo_kick/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:spo_kick/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:spo_kick/features/auth/domain/repositories/auth_repository.dart';
import 'package:spo_kick/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/login_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/logout_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/register_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';

// Fields Feature
import 'package:spo_kick/features/fields/data/datasources/field_remote_datasource.dart';
import 'package:spo_kick/features/fields/data/repositories/field_repository_impl.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';
import 'package:spo_kick/features/fields/domain/usecases/advanced_search_fields_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_all_fields_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_field_by_id_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_fields_by_category_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_featured_fields_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_sport_categories_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/search_fields_usecase.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';

// Bookings Feature
import 'package:spo_kick/features/bookings/data/datasources/booking_admin_operations_datasource.dart';
import 'package:spo_kick/features/bookings/data/datasources/booking_owner_operations_datasource.dart';
import 'package:spo_kick/features/bookings/data/datasources/booking_remote_datasource_facade.dart';
import 'package:spo_kick/features/bookings/data/datasources/booking_time_slot_datasource.dart';
import 'package:spo_kick/features/bookings/data/datasources/booking_user_operations_datasource.dart';
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
import 'package:spo_kick/features/super_admin/data/datasources/super_admin_city_management_datasource.dart';
import 'package:spo_kick/features/super_admin/data/datasources/super_admin_field_management_datasource.dart';
import 'package:spo_kick/features/super_admin/data/datasources/super_admin_remote_datasource_facade.dart';
import 'package:spo_kick/features/super_admin/data/datasources/super_admin_statistics_datasource.dart';
import 'package:spo_kick/features/super_admin/data/datasources/super_admin_user_management_datasource.dart';
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

// Settings Feature
import 'package:spo_kick/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:spo_kick/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:spo_kick/features/settings/domain/repositories/settings_repository.dart';
import 'package:spo_kick/features/settings/domain/usecases/get_user_preferences_usecase.dart';
import 'package:spo_kick/features/settings/domain/usecases/reset_preferences_usecase.dart';
import 'package:spo_kick/features/settings/domain/usecases/update_user_preferences_usecase.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';

// City Feature
import 'package:spo_kick/features/city/data/datasources/city_local_data_source.dart';
import 'package:spo_kick/features/city/data/datasources/city_remote_data_source.dart';
import 'package:spo_kick/features/city/data/repositories/city_repository_impl.dart';
import 'package:spo_kick/features/city/domain/repositories/city_repository.dart';
import 'package:spo_kick/features/city/domain/usecases/clear_selected_city_usecase.dart';
import 'package:spo_kick/features/city/domain/usecases/get_cities_usecase.dart';
import 'package:spo_kick/features/city/domain/usecases/get_city_by_id_usecase.dart';
import 'package:spo_kick/features/city/domain/usecases/get_selected_city_usecase.dart';
import 'package:spo_kick/features/city/domain/usecases/save_selected_city_usecase.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';

import 'package:spo_kick/features/owner/domain/usecases/approve_booking_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/delete_field_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_bookings_usecase.dart'
    as owner;
import 'package:spo_kick/features/owner/domain/usecases/get_owner_fields_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_revenue_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/reject_booking_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/update_field_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/update_owner_profile_usecase.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/data/datasources/owner_remote_datasource.dart';
import 'package:spo_kick/features/owner/data/datasources/owner_remote_datasource_impl.dart';
import 'package:spo_kick/features/owner/data/repositories/owner_repository_impl.dart';
import 'package:spo_kick/features/owner/domain/repositories/owner_repository.dart';

// Favorites Feature
import 'package:spo_kick/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:spo_kick/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:spo_kick/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:spo_kick/features/favorites/domain/usecases/add_to_favorites_usecase.dart';
import 'package:spo_kick/features/favorites/domain/usecases/get_favorite_field_ids_usecase.dart';
import 'package:spo_kick/features/favorites/domain/usecases/is_favorite_usecase.dart';
import 'package:spo_kick/features/favorites/domain/usecases/remove_from_favorites_usecase.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_cubit.dart';

// Reviews Feature
import 'package:spo_kick/features/reviews/data/datasources/review_remote_datasource.dart';
import 'package:spo_kick/features/reviews/data/repositories/review_repository_impl.dart';
import 'package:spo_kick/features/reviews/domain/repositories/review_repository.dart';
import 'package:spo_kick/features/reviews/domain/usecases/can_user_review_field_usecase.dart';
import 'package:spo_kick/features/reviews/domain/usecases/create_review_usecase.dart';
import 'package:spo_kick/features/reviews/domain/usecases/delete_review_usecase.dart';
import 'package:spo_kick/features/reviews/domain/usecases/get_field_reviews_usecase.dart';
import 'package:spo_kick/features/reviews/domain/usecases/update_review_usecase.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';

// Business Hours Feature
import 'package:spo_kick/features/business_hours/data/datasources/business_hours_remote_datasource.dart';
import 'package:spo_kick/features/business_hours/data/datasources/business_hours_remote_datasource_impl.dart';
import 'package:spo_kick/features/business_hours/data/repositories/business_hours_repository_impl.dart';
import 'package:spo_kick/features/business_hours/domain/repositories/business_hours_repository.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/get_field_business_hours_usecase.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/initialize_default_business_hours_usecase.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/is_field_currently_open_usecase.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/update_business_hours_usecase.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/validate_booking_time_usecase.dart';
import 'package:spo_kick/features/business_hours/presentation/cubit/business_hours_cubit.dart';

import '../../features/auth/domain/usecases/update_profile_usecase.dart';

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

  // Owner Feature
  _initOwner();

  // Settings Feature
  _initSettings();

  // City Feature
  _initCity();

  // Favorites Feature
  _initFavorites();

  // Reviews Feature
  _initReviews();

  // Business Hours Feature
  _initBusinessHours();
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

  // Note: ApiClient removed - app uses Supabase directly, not REST APIs

  // CSV Export Service
  sl.registerLazySingleton<CsvExportService>(() => CsvExportService());

  // PDF Export Service
  sl.registerLazySingleton<PdfExportService>(() => PdfExportService());

  // Error Logging Service
  sl.registerLazySingleton<ErrorLoggingService>(() => ErrorLoggingService());
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
      changePasswordUseCase: sl(),
      resetPasswordUseCase: sl(),
      updateProfileUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

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
  sl.registerLazySingleton(() => AdvancedSearchFieldsUseCase(sl()));

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

  // Data Sources - Specialized datasources
  sl.registerLazySingleton<BookingUserOperationsDataSource>(
    () => BookingUserOperationsDataSourceImpl(supabaseClient: sl()),
  );

  sl.registerLazySingleton<BookingTimeSlotDataSource>(
    () => BookingTimeSlotDataSourceImpl(supabaseClient: sl()),
  );

  sl.registerLazySingleton<BookingOwnerOperationsDataSource>(
    () => BookingOwnerOperationsDataSourceImpl(supabaseClient: sl()),
  );

  sl.registerLazySingleton<BookingAdminOperationsDataSource>(
    () => BookingAdminOperationsDataSourceImpl(supabaseClient: sl()),
  );

  // Data Sources - Facade for backward compatibility
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceFacade(
      userOperationsDataSource: sl(),
      timeSlotDataSource: sl(),
      ownerOperationsDataSource: sl(),
      adminOperationsDataSource: sl(),
    ),
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

  // Data Sources - Specialized datasources
  sl.registerLazySingleton<SuperAdminStatisticsDataSource>(
    () => SuperAdminStatisticsDataSourceImpl(supabaseClient: sl()),
  );

  sl.registerLazySingleton<SuperAdminUserManagementDataSource>(
    () => SuperAdminUserManagementDataSourceImpl(supabaseClient: sl()),
  );

  sl.registerLazySingleton<SuperAdminFieldManagementDataSource>(
    () => SuperAdminFieldManagementDataSourceImpl(supabaseClient: sl()),
  );

  sl.registerLazySingleton<SuperAdminCityManagementDataSource>(
    () => SuperAdminCityManagementDataSourceImpl(supabaseClient: sl()),
  );

  // Data Sources - Facade for backward compatibility
  sl.registerLazySingleton<SuperAdminRemoteDataSource>(
    () => SuperAdminRemoteDataSourceFacade(
      statisticsDataSource: sl(),
      userManagementDataSource: sl(),
      fieldManagementDataSource: sl(),
      cityManagementDataSource: sl(),
    ),
  );
}

// ==================== FEATURE: OWNER ====================

/// Initialize owner (field owner/admin) feature dependencies.
///
/// Registers all dependencies for the owner dashboard:
/// - Owner cubit for state management
/// - Use cases for business logic
/// - Repository for data access
/// - Remote data source for API calls
void _initOwner() {
  // Cubit
  sl.registerFactory(
    () => OwnerCubit(
      getOwnerFieldsUseCase: sl(),
      updateFieldUseCase: sl(),
      getOwnerBookingsUseCase: sl(),
      approveBookingUseCase: sl(),
      rejectBookingUseCase: sl(),
      getOwnerRevenueUseCase: sl(),
      updateOwnerProfileUseCase: sl(),
      deleteFieldUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetOwnerFieldsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateFieldUseCase(sl()));
  sl.registerLazySingleton(() => owner.GetOwnerBookingsUseCase(sl()));
  sl.registerLazySingleton(() => ApproveBookingUseCase(sl()));
  sl.registerLazySingleton(() => RejectBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetOwnerRevenueUseCase(sl()));
  sl.registerLazySingleton(() => UpdateOwnerProfileUseCase(sl()));
  sl.registerLazySingleton(() => DeleteFieldUseCase(sl()));

  // Repository
  sl.registerLazySingleton<OwnerRepository>(() => OwnerRepositoryImpl(sl()));

  // Data Sources
  sl.registerLazySingleton<OwnerRemoteDataSource>(
    () => OwnerRemoteDataSourceImpl(sl()),
  );
}

// ==================== FEATURE: SETTINGS ====================

/// Initialize settings feature dependencies.
///
/// Registers all dependencies for user settings and preferences:
/// - Settings cubit for state management
/// - Use cases for preferences management
/// - Repository for data access
/// - Local data source for persistent storage
void _initSettings() {
  // Cubit
  sl.registerFactory(
    () => SettingsCubit(
      getUserPreferences: sl(),
      updateUserPreferences: sl(),
      resetPreferences: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetUserPreferencesUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserPreferencesUseCase(sl()));
  sl.registerLazySingleton(() => ResetPreferencesUseCase(sl()));

  // Repository
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sharedPreferences: sl()),
  );
}

// ==================== FEATURE: CITY ====================

/// Initialize city feature dependencies.
///
/// Registers all dependencies for city selection:
/// - City cubit for state management
/// - Use cases for city operations
/// - Repository for data access
/// - Remote and local data sources
void _initCity() {
  // Cubit
  sl.registerFactory(
    () => CityCubit(
      getCities: sl(),
      saveSelectedCity: sl(),
      getSelectedCity: sl(),
      clearSelectedCity: sl(),
      getCityById: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetCitiesUseCase(sl()));
  sl.registerLazySingleton(() => SaveSelectedCityUseCase(sl()));
  sl.registerLazySingleton(() => GetSelectedCityUseCase(sl()));
  sl.registerLazySingleton(() => ClearSelectedCityUseCase(sl()));
  sl.registerLazySingleton(() => GetCityByIdUseCase(sl()));

  // Repository
  sl.registerLazySingleton<CityRepository>(
    () => CityRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<CityRemoteDataSource>(
    () => CityRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CityLocalDataSource>(
    () => CityLocalDataSourceImpl(sl()),
  );
}

// ==================== FEATURE: FAVORITES ====================

/// Initialize favorites feature dependencies.
///
/// Registers all dependencies for the favorites feature:
/// - Favorites cubit for state management
/// - Use cases for favorites operations
/// - Repository for data access
/// - Local data source for SharedPreferences storage
void _initFavorites() {
  // Cubit
  sl.registerFactory(
    () => FavoritesCubit(
      isFavoriteUseCase: sl(),
      addToFavoritesUseCase: sl(),
      removeFromFavoritesUseCase: sl(),
      getFavoriteFieldIdsUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => IsFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => AddToFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => GetFavoriteFieldIdsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(sharedPreferences: sl()),
  );
}

/// Initialize reviews feature dependencies.
///
/// Dependencies hierarchy:
/// Cubit -> Use Cases -> Repository -> Data Source -> Supabase
void _initReviews() {
  // Cubit
  sl.registerFactory(
    () => ReviewsCubit(
      createReviewUseCase: sl(),
      getFieldReviewsUseCase: sl(),
      updateReviewUseCase: sl(),
      deleteReviewUseCase: sl(),
      canUserReviewFieldUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => CreateReviewUseCase(sl()));
  sl.registerLazySingleton(() => GetFieldReviewsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateReviewUseCase(sl()));
  sl.registerLazySingleton(() => DeleteReviewUseCase(sl()));
  sl.registerLazySingleton(() => CanUserReviewFieldUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ReviewRemoteDataSource>(
    () => ReviewRemoteDataSourceImpl(supabaseClient: sl()),
  );
}

// ==================== FEATURE: BUSINESS HOURS ====================

/// Initialize business hours feature dependencies.
///
/// Dependencies hierarchy:
/// - Cubits (Factory) depend on UseCases
/// - UseCases (LazySingleton) depend on Repositories
/// - Repositories (LazySingleton) depend on Data Sources
/// - Data Sources (LazySingleton) depend on External services
void _initBusinessHours() {
  // Cubit
  sl.registerFactory(
    () => BusinessHoursCubit(
      getFieldBusinessHoursUseCase: sl(),
      updateBusinessHoursUseCase: sl(),
      initializeDefaultBusinessHoursUseCase: sl(),
      validateBookingTimeUseCase: sl(),
      isFieldCurrentlyOpenUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetFieldBusinessHoursUseCase(sl()));
  sl.registerLazySingleton(() => UpdateBusinessHoursUseCase(sl()));
  sl.registerLazySingleton(() => InitializeDefaultBusinessHoursUseCase(sl()));
  sl.registerLazySingleton(() => ValidateBookingTimeUseCase(sl()));
  sl.registerLazySingleton(() => IsFieldCurrentlyOpenUseCase(sl()));

  // Repository
  sl.registerLazySingleton<BusinessHoursRepository>(
    () => BusinessHoursRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<BusinessHoursRemoteDataSource>(
    () => BusinessHoursRemoteDataSourceImpl(supabaseClient: sl()),
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
Future<void> resetDependencies() async {
  await sl.reset();
}

/// Check if a dependency is registered.
///
/// Useful for debugging dependency issues.
bool isDependencyRegistered<T extends Object>() {
  return sl.isRegistered<T>();
}

/// Get debug information about registered dependencies.
///
/// Useful for debugging dependency issues.
String getRegistrationDebugInfo() {
  return '''
GetIt Registration Info:
- Has registrations: ${sl.allReadySync()}
- Ready count: ${sl.allReadySync() ? 'All ready' : 'Not all ready'}

To check if a specific type is registered, use:
-isDependencyRegistered<YourType>()
''';
}
