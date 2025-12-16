import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/core/services/csv_export_service.dart';
import 'package:spo_kick/core/services/pdf_export_service.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/auth/domain/repositories/auth_repository.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/bookings/domain/repositories/booking_repository.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_all_fields_usecase.dart';
import 'package:spo_kick/features/fields/data/datasources/field_remote_datasource.dart';
import 'package:spo_kick/features/bookings/data/datasources/booking_remote_datasource_facade.dart';
import 'package:spo_kick/features/owner/data/datasources/owner_remote_datasource.dart';
import 'package:spo_kick/features/owner/domain/repositories/owner_repository.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/super_admin/data/datasources/super_admin_remote_datasource_facade.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/activate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/assign_field_to_admin_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_admin_account_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_field_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/deactivate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_active_cities_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_city_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/update_city_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/delete_city_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_admins_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_bookings_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_users_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_platform_statistics_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/update_field_usecase.dart'
    as super_admin_update;
import 'package:spo_kick/features/super_admin/domain/usecases/delete_field_usecase.dart'
    as super_admin_delete;
import 'package:spo_kick/features/super_admin/domain/usecases/verify_field_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/approve_booking_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_bookings_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_fields_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_revenue_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/reject_booking_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/update_field_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/update_owner_profile_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/delete_field_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_field_by_id_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_fields_by_category_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_featured_fields_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_sport_categories_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/search_fields_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/cancel_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/create_manual_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_available_time_slots_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_booking_by_id_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_owner_bookings_usecase.dart'
    as bookings_usecase;
import 'package:spo_kick/features/bookings/domain/usecases/get_user_bookings_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/update_booking_status_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';

// ============================================================================
// MOCK REPOSITORIES
// ============================================================================

/// Mock SuperAdminRepository for testing
class MockSuperAdminRepository extends Mock implements SuperAdminRepository {}

/// Mock OwnerRepository for testing
class MockOwnerRepository extends Mock implements OwnerRepository {}

/// Mock FieldRepository for testing
class MockFieldRepository extends Mock implements FieldRepository {}

/// Mock BookingRepository for testing
class MockBookingRepository extends Mock implements BookingRepository {}

/// Mock AuthRepository for testing
class MockAuthRepository extends Mock implements AuthRepository {}

// ============================================================================
// MOCK USE CASES - SuperAdmin
// ============================================================================

/// Mock GetPlatformStatisticsUseCase
class MockGetPlatformStatisticsUseCase extends Mock
    implements GetPlatformStatisticsUseCase {}

/// Mock CreateAdminAccountUseCase
class MockCreateAdminAccountUseCase extends Mock
    implements CreateAdminAccountUseCase {}

/// Mock GetAllAdminsUseCase
class MockGetAllAdminsUseCase extends Mock implements GetAllAdminsUseCase {}

/// Mock GetAllUsersUseCase
class MockGetAllUsersUseCase extends Mock implements GetAllUsersUseCase {}

/// Mock AssignFieldToAdminUseCase
class MockAssignFieldToAdminUseCase extends Mock
    implements AssignFieldToAdminUseCase {}

/// Mock GetActiveCitiesUseCase
class MockGetActiveCitiesUseCase extends Mock
    implements GetActiveCitiesUseCase {}

/// Mock ActivateUserUseCase
class MockActivateUserUseCase extends Mock implements ActivateUserUseCase {}

/// Mock DeactivateUserUseCase
class MockDeactivateUserUseCase extends Mock implements DeactivateUserUseCase {}

/// Mock CreateFieldUseCase
class MockCreateFieldUseCase extends Mock implements CreateFieldUseCase {}

/// Mock GetAllFieldsUseCase
class MockGetAllFieldsUseCase extends Mock implements GetAllFieldsUseCase {}

/// Mock GetAllBookingsUseCase
class MockGetAllBookingsUseCase extends Mock implements GetAllBookingsUseCase {}

/// Mock Super Admin UpdateFieldUseCase
class MockSuperAdminUpdateFieldUseCase extends Mock
    implements super_admin_update.UpdateFieldUseCase {}

/// Mock Super Admin DeleteFieldUseCase
class MockSuperAdminDeleteFieldUseCase extends Mock
    implements super_admin_delete.DeleteFieldUseCase {}

/// Mock VerifyFieldUseCase
class MockVerifyFieldUseCase extends Mock implements VerifyFieldUseCase {}

/// Mock CreateCityUseCase
class MockCreateCityUseCase extends Mock implements CreateCityUseCase {}

/// Mock UpdateCityUseCase
class MockUpdateCityUseCase extends Mock implements UpdateCityUseCase {}

/// Mock DeleteCityUseCase
class MockDeleteCityUseCase extends Mock implements DeleteCityUseCase {}

// ============================================================================
// MOCK USE CASES - Owner
// ============================================================================

/// Mock GetOwnerFieldsUseCase
class MockGetOwnerFieldsUseCase extends Mock implements GetOwnerFieldsUseCase {}

/// Mock UpdateFieldUseCase
class MockUpdateFieldUseCase extends Mock implements UpdateFieldUseCase {}

/// Mock GetOwnerBookingsUseCase
class MockGetOwnerBookingsUseCase extends Mock
    implements GetOwnerBookingsUseCase {}

/// Mock ApproveBookingUseCase
class MockApproveBookingUseCase extends Mock implements ApproveBookingUseCase {}

/// Mock RejectBookingUseCase
class MockRejectBookingUseCase extends Mock implements RejectBookingUseCase {}

/// Mock GetOwnerRevenueUseCase
class MockGetOwnerRevenueUseCase extends Mock
    implements GetOwnerRevenueUseCase {}

/// Mock UpdateOwnerProfileUseCase
class MockUpdateOwnerProfileUseCase extends Mock
    implements UpdateOwnerProfileUseCase {}

/// Mock DeleteFieldUseCase
class MockDeleteFieldUseCase extends Mock implements DeleteFieldUseCase {}

// ============================================================================
// MOCK USE CASES - Fields
// ============================================================================

/// Mock GetFieldByIdUseCase
class MockGetFieldByIdUseCase extends Mock implements GetFieldByIdUseCase {}

/// Mock GetFieldsByCategoryUseCase
class MockGetFieldsByCategoryUseCase extends Mock
    implements GetFieldsByCategoryUseCase {}

/// Mock GetFeaturedFieldsUseCase
class MockGetFeaturedFieldsUseCase extends Mock
    implements GetFeaturedFieldsUseCase {}

/// Mock GetSportCategoriesUseCase
class MockGetSportCategoriesUseCase extends Mock
    implements GetSportCategoriesUseCase {}

/// Mock SearchFieldsUseCase
class MockSearchFieldsUseCase extends Mock implements SearchFieldsUseCase {}

// ============================================================================
// MOCK USE CASES - Bookings
// ============================================================================

/// Mock GetAvailableTimeSlotsUseCase
class MockGetAvailableTimeSlotsUseCase extends Mock
    implements GetAvailableTimeSlotsUseCase {}

/// Mock CreateBookingUseCase
class MockCreateBookingUseCase extends Mock implements CreateBookingUseCase {}

/// Mock CreateManualBookingUseCase
class MockCreateManualBookingUseCase extends Mock
    implements CreateManualBookingUseCase {}

/// Mock GetUserBookingsUseCase
class MockGetUserBookingsUseCase extends Mock
    implements GetUserBookingsUseCase {}

/// Mock GetBookingByIdUseCase
class MockGetBookingByIdUseCase extends Mock implements GetBookingByIdUseCase {}

/// Mock CancelBookingUseCase
class MockCancelBookingUseCase extends Mock implements CancelBookingUseCase {}

/// Mock UpdateBookingStatusUseCase
class MockUpdateBookingStatusUseCase extends Mock
    implements UpdateBookingStatusUseCase {}

/// Mock GetOwnerBookingsUseCase (Bookings Feature)
class MockBookingGetOwnerBookingsUseCase extends Mock
    implements bookings_usecase.GetOwnerBookingsUseCase {}

// ============================================================================
// MOCK DATA SOURCES
// ============================================================================

/// Mock SuperAdminRemoteDataSource
class MockSuperAdminRemoteDataSource extends Mock
    implements SuperAdminRemoteDataSource {}

/// Mock FieldRemoteDataSource
class MockFieldRemoteDataSource extends Mock implements FieldRemoteDataSource {}

/// Mock BookingRemoteDataSource
class MockBookingRemoteDataSource extends Mock
    implements BookingRemoteDataSource {}

/// Mock OwnerRemoteDataSource
class MockOwnerRemoteDataSource extends Mock implements OwnerRemoteDataSource {}

// ============================================================================
// MOCK SERVICES
// ============================================================================

/// Mock CsvExportService
class MockCsvExportService extends Mock implements CsvExportService {}

/// Mock PdfExportService
class MockPdfExportService extends Mock implements PdfExportService {}

// ============================================================================
// MOCK CUBITS
// ============================================================================

/// Mock AuthCubit
class MockAuthCubit extends Mock implements AuthCubit {}

/// Mock SuperAdminCubit
class MockSuperAdminCubit extends Mock implements SuperAdminCubit {}

/// Mock OwnerCubit
class MockOwnerCubit extends Mock implements OwnerCubit {}

// ============================================================================
// MOCK EXTERNAL DEPENDENCIES
// ============================================================================

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class MockPostgrestFilterBuilder extends Mock
    implements PostgrestFilterBuilder<PostgrestList> {}

class MockPostgrestTransformBuilder extends Mock
    implements PostgrestTransformBuilder {}

class MockFunctionsClient extends Mock implements FunctionsClient {}

class MockFunctionResponse extends Mock implements FunctionResponse {}

/// Fake PostgrestTransformBuilder that can be awaited
class FakePostgrestTransformBuilder<T> extends Fake
    implements PostgrestTransformBuilder<T> {
  final T _result;

  FakePostgrestTransformBuilder(this._result);

  @override
  Future<R> then<R>(
    FutureOr<R> Function(T value) onValue, {
    Function? onError,
  }) async {
    return onValue(_result);
  }
}

// ============================================================================
// TEST HELPERS
// ============================================================================

/// Register fallback values for mocktail
void registerFallbackValues() {
  final now = DateTime.now();

  // Register entity fallbacks
  registerFallbackValue(
    UserEntity(
      id: 'fallback-id',
      email: 'fallback@test.com',
      fullName: 'Fallback User',
      role: 'user',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    ),
  );

  registerFallbackValue(
    FieldEntity(
      id: 'fallback-field-id',
      name: 'Fallback Field',
      sportCategoryId: 'fallback-sport-id',
      ownerId: 'fallback-owner-id',
      city: 'Cairo',
      address: 'Fallback Address',
      pricePerHour: 100.0,
      currency: 'EGP',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    ),
  );

  // Register failure fallbacks
  registerFallbackValue(const ServerFailure());
  registerFallbackValue(const NetworkFailure());
  registerFallbackValue(const CacheFailure());
  registerFallbackValue(const ValidationFailure());
  registerFallbackValue(<String, dynamic>{});
}

/// Pump widget with MaterialApp wrapper for widget tests
Future<void> pumpWidgetWithMaterialApp(
  WidgetTester tester,
  Widget widget,
) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));
}

/// Pump widget with full app dependencies
Future<void> pumpWidgetWithDependencies(
  WidgetTester tester,
  Widget widget, {
  required MockAuthCubit mockAuthCubit,
  MockSuperAdminCubit? mockSuperAdminCubit,
  MockOwnerCubit? mockOwnerCubit,
}) async {
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: mockAuthCubit),
        if (mockSuperAdminCubit != null)
          BlocProvider<SuperAdminCubit>.value(value: mockSuperAdminCubit),
        if (mockOwnerCubit != null)
          BlocProvider<OwnerCubit>.value(value: mockOwnerCubit),
      ],
      child: MaterialApp(home: Scaffold(body: widget)),
    ),
  );
}

/// Wait for all animations and async operations
Future<void> pumpAndSettleWithDelay(
  WidgetTester tester, {
  Duration delay = const Duration(milliseconds: 100),
}) async {
  await tester.pump(delay);
  await tester.pumpAndSettle();
}

/// Verify that a cubit emits expected states in order
void verifyStateEmissions<T>(
  Stream<T> stream,
  List<T> expectedStates, {
  String? description,
}) {
  expect(
    stream,
    emitsInOrder(expectedStates),
    reason: description ?? 'States should be emitted in expected order',
  );
}

/// Create a matcher for Either Right value
Matcher isRight<L, R>(R expected) {
  return predicate<Either<L, R>>(
    (either) =>
        either.isRight() && either.getOrElse(() => null as R) == expected,
    'is Right($expected)',
  );
}

/// Create a matcher for Either Left value
Matcher isLeft<L, R>(L expected) {
  return predicate<Either<L, R>>(
    (either) =>
        either.isLeft() && either.fold((l) => l, (r) => null as L) == expected,
    'is Left($expected)',
  );
}

/// Create a matcher for Either Right type (ignoring value)
Matcher isRightType<L, R>() {
  return predicate<Either<L, R>>(
    (either) => either.isRight(),
    'is Right (any value)',
  );
}

/// Create a matcher for Either Left type (ignoring value)
Matcher isLeftType<L, R>() {
  return predicate<Either<L, R>>(
    (either) => either.isLeft(),
    'is Left (any value)',
  );
}

/// Verify that a use case was called with specific parameters
void verifyUseCaseCall<T>(
  T useCase,
  dynamic Function() verification, {
  int times = 1,
}) {
  verify(verification).called(times);
}

/// Verify that a use case was never called
void verifyUseCaseNeverCalled<T>(T useCase, dynamic Function() verification) {
  verifyNever(verification);
}

/// Create a test description with category prefix
String testDescription(String category, String description) {
  return '[$category] $description';
}

/// Group tests by feature
void featureGroup(String featureName, void Function() body) {
  group('Feature: $featureName', body);
}

/// Group tests by layer
void layerGroup(String layerName, void Function() body) {
  group('Layer: $layerName', body);
}

/// Group tests by component
void componentGroup(String componentName, void Function() body) {
  group('Component: $componentName', body);
}
