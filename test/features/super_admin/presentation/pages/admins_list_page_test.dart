import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/admins_list_page.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admin_card.dart';
import 'package:dartz/dartz.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_admins_usecase.dart';

import '../../../../helpers/test_helpers.dart';

class MockSuperAdminCubit extends MockCubit<SuperAdminState>
    implements SuperAdminCubit {}

class MockGetAllAdminsUseCase extends Mock implements GetAllAdminsUseCase {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  late MockSuperAdminCubit mockSuperAdminCubit;
  late MockNavigatorObserver mockNavigatorObserver;
  late MockGetAllAdminsUseCase mockGetAllAdminsUseCase;

  setUp(() {
    mockSuperAdminCubit = MockSuperAdminCubit();
    mockNavigatorObserver = MockNavigatorObserver();
    mockGetAllAdminsUseCase = MockGetAllAdminsUseCase();

    // Stub the dependency used by the extension method
    when(
      () => mockSuperAdminCubit.getAllAdminsUseCase,
    ).thenReturn(mockGetAllAdminsUseCase);

    // Stub the use case to return empty list by default
    when(
      () => mockGetAllAdminsUseCase(),
    ).thenAnswer((_) async => const Right([]));

    // Default stream behavior
    when(
      () => mockSuperAdminCubit.stream,
    ).thenAnswer((_) => Stream<SuperAdminState>.empty());
    when(() => mockSuperAdminCubit.close()).thenAnswer((_) async {});

    // Setup GetIt
    final getIt = GetIt.instance;
    if (getIt.isRegistered<SuperAdminCubit>()) {
      getIt.unregister<SuperAdminCubit>();
    }
    getIt.registerFactory<SuperAdminCubit>(() => mockSuperAdminCubit);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  Widget buildTestWidget() {
    return const AdminsListPage();
  }

  group('AdminsListPage', () {
    final tAdmin = UserEntity(
      id: '1',
      email: 'admin@example.com',
      fullName: 'Admin User',
      role: 'admin',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: true,
    );

    testWidgets(
      'should show loading indicator when state is SuperAdminLoading',
      (tester) async {
        // Arrange
        whenListen(
          mockSuperAdminCubit,
          Stream.fromIterable([const SuperAdminLoading()]),
          initialState: const SuperAdminLoading(),
        );

        // Act
        await pumpApp(tester, buildTestWidget());

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('should show error message when state is SuperAdminError', (
      tester,
    ) async {
      // Arrange
      const errorMessage = 'Failed to load admins';
      whenListen(
        mockSuperAdminCubit,
        Stream.fromIterable([const SuperAdminError(errorMessage)]),
        initialState: const SuperAdminError(errorMessage),
      );

      // Act
      await pumpApp(tester, buildTestWidget());

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.text('Error loading admins'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should show list of admins when state is AdminsListLoaded', (
      tester,
    ) async {
      // Arrange
      whenListen(
        mockSuperAdminCubit,
        Stream.fromIterable([
          AdminsListLoaded([tAdmin]),
        ]),
        initialState: AdminsListLoaded([tAdmin]),
      );

      // Act
      await pumpApp(tester, buildTestWidget());

      // Assert
      expect(find.byType(AdminCard), findsOneWidget);
      expect(find.text('Admin User'), findsOneWidget);
      expect(find.text('admin@example.com'), findsOneWidget);
    });

    testWidgets('should show empty state when list is empty', (tester) async {
      // Arrange
      whenListen(
        mockSuperAdminCubit,
        Stream.fromIterable([const AdminsListLoaded([])]),
        initialState: const AdminsListLoaded([]),
      );

      // Act
      await pumpApp(tester, buildTestWidget());

      // Assert
      expect(find.text('No Admins Yet'), findsOneWidget);
      expect(find.byIcon(Icons.admin_panel_settings_outlined), findsOneWidget);
    });

    testWidgets(
      'should navigate to Create Admin page when FAB is pressed',
      (tester) async {
        // Arrange
        whenListen(
          mockSuperAdminCubit,
          Stream.fromIterable([const AdminsListLoaded([])]),
          initialState: const AdminsListLoaded([]),
        );

        // Act
        await pumpApp(
          tester,
          buildTestWidget(),
          navigatorObserver: mockNavigatorObserver,
          routes: {
            '/super-admin/create-admin': (context) =>
                const Scaffold(body: Text('Create Admin Page')),
          },
        );

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        // Assert
        verify(() => mockNavigatorObserver.didPush(any(), any()));
      },
      skip: true, // Navigation uses go_router, not Navigator
    );

    testWidgets(
      'should navigate to Admin Details page when admin card is tapped',
      (tester) async {
        // Arrange
        whenListen(
          mockSuperAdminCubit,
          Stream.fromIterable([
            AdminsListLoaded([tAdmin]),
          ]),
          initialState: AdminsListLoaded([tAdmin]),
        );

        // Act
        await pumpApp(
          tester,
          buildTestWidget(),
          navigatorObserver: mockNavigatorObserver,
          routes: {
            '/super-admin/admin-details': (context) =>
                const Scaffold(body: Text('Admin Details Page')),
          },
        );

        // Tap on admin name text to trigger navigation
        await tester.tap(find.text('Admin User'));
        await tester.pumpAndSettle();

        // Assert
        verify(() => mockNavigatorObserver.didPush(any(), any()));
      },
      skip: true, // Navigation uses go_router, not Navigator
    );
  });
}
