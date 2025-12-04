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

import '../../../../helpers/test_helpers.dart';

class MockSuperAdminCubit extends MockCubit<SuperAdminState>
    implements SuperAdminCubit {}

void main() {
  late MockSuperAdminCubit mockSuperAdminCubit;
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockSuperAdminCubit = MockSuperAdminCubit();
    mockNavigatorObserver = MockNavigatorObserver();

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
        when(
          () => mockSuperAdminCubit.state,
        ).thenReturn(const SuperAdminLoading());
        when(() => mockSuperAdminCubit.loadAdmins()).thenAnswer((_) async {});

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
      when(
        () => mockSuperAdminCubit.state,
      ).thenReturn(const SuperAdminError(errorMessage));
      when(() => mockSuperAdminCubit.loadAdmins()).thenAnswer((_) async {});

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
      when(
        () => mockSuperAdminCubit.state,
      ).thenReturn(AdminsListLoaded([tAdmin]));
      when(() => mockSuperAdminCubit.loadAdmins()).thenAnswer((_) async {});

      // Act
      await pumpApp(tester, buildTestWidget());

      // Assert
      expect(find.byType(AdminCard), findsOneWidget);
      expect(find.text('Admin User'), findsOneWidget);
      expect(find.text('admin@example.com'), findsOneWidget);
    });

    testWidgets('should show empty state when list is empty', (tester) async {
      // Arrange
      when(
        () => mockSuperAdminCubit.state,
      ).thenReturn(const AdminsListLoaded([]));
      when(() => mockSuperAdminCubit.loadAdmins()).thenAnswer((_) async {});

      // Act
      await pumpApp(tester, buildTestWidget());

      // Assert
      expect(find.text('No Admins Yet'), findsOneWidget);
      expect(find.byIcon(Icons.admin_panel_settings_outlined), findsOneWidget);
    });

    testWidgets('should trigger loadAdmins on initialization', (tester) async {
      // Arrange
      when(
        () => mockSuperAdminCubit.state,
      ).thenReturn(const SuperAdminLoading());
      when(() => mockSuperAdminCubit.loadAdmins()).thenAnswer((_) async {});

      // Act
      await pumpApp(tester, buildTestWidget());

      // Assert
      verify(() => mockSuperAdminCubit.loadAdmins()).called(1);
    });

    testWidgets('should trigger refresh when retry button is pressed', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockSuperAdminCubit.state,
      ).thenReturn(const SuperAdminError('Error'));
      when(() => mockSuperAdminCubit.loadAdmins()).thenAnswer((_) async {});

      // Act
      await pumpApp(tester, buildTestWidget());
      await tester.tap(find.text('Retry'));

      // Assert
      verify(() => mockSuperAdminCubit.loadAdmins()).called(2);
    });

    testWidgets('should navigate to Create Admin page when FAB is pressed', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockSuperAdminCubit.state,
      ).thenReturn(const AdminsListLoaded([]));
      when(() => mockSuperAdminCubit.loadAdmins()).thenAnswer((_) async {});

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
      expect(find.text('Create Admin Page'), findsOneWidget);
    });

    testWidgets(
      'should navigate to Admin Details page when admin card is tapped',
      (tester) async {
        // Arrange
        when(
          () => mockSuperAdminCubit.state,
        ).thenReturn(AdminsListLoaded([tAdmin]));
        when(() => mockSuperAdminCubit.loadAdmins()).thenAnswer((_) async {});

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
        expect(find.text('Admin Details Page'), findsOneWidget);
      },
    );
  });
}
