import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admins_list/super_admin_admins_list_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admins_list/super_admin_admins_list_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/premium_admin_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/admins_list/premium_super_admin_admins_list_view.dart';

class MockSuperAdminAdminsListCubit extends MockCubit<SuperAdminAdminsListState>
    implements SuperAdminAdminsListCubit {}

void main() {
  late MockSuperAdminAdminsListCubit mockAdminsListCubit;

  void setCubitState(SuperAdminAdminsListState state) {
    when(() => mockAdminsListCubit.state).thenReturn(state);
    whenListen(mockAdminsListCubit, Stream.value(state), initialState: state);
  }

  setUp(() {
    mockAdminsListCubit = MockSuperAdminAdminsListCubit();
    setCubitState(const SuperAdminAdminsListLoading());
    when(() => mockAdminsListCubit.loadAdmins()).thenAnswer((_) async {});
    when(() => mockAdminsListCubit.refresh()).thenAnswer((_) async {});
    when(() => mockAdminsListCubit.close()).thenAnswer((_) async {});
    when(() => mockAdminsListCubit.getStats()).thenAnswer((_) {
      final state = mockAdminsListCubit.state;
      if (state is SuperAdminAdminsListLoaded) {
        return {
          'total': state.allAdmins.length,
          'active': state.activeCount,
          'inactive': state.inactiveCount,
        };
      }
      return {'total': 0, 'active': 0, 'inactive': 0};
    });
  });

  Widget buildTestWidget() {
    return BlocProvider<SuperAdminAdminsListCubit>.value(
      value: mockAdminsListCubit,
      child: const PremiumSuperAdminAdminsListView(),
    );
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
      'shows loading placeholder when state is SuperAdminAdminsListLoading',
      (tester) async {
        // Arrange
        setCubitState(const SuperAdminAdminsListLoading());

        // Act
        await tester.pumpWidget(MaterialApp(home: buildTestWidget()));
        await tester.pump(); // settle initial frame

        // Assert
        verify(() => mockAdminsListCubit.loadAdmins()).called(1);
        expect(find.text('Create Admin'), findsOneWidget);
        expect(find.byType(GridView), findsOneWidget); // shimmer grid
      },
    );

    testWidgets('shows error message when state is SuperAdminAdminsListError', (
      tester,
    ) async {
      // Arrange
      const errorMessage = 'Failed to load admins';
      setCubitState(const SuperAdminAdminsListError(errorMessage));

      // Act
      await tester.pumpWidget(MaterialApp(home: buildTestWidget()));
      await tester.pump();

      // Assert
      expect(find.text('Failed to load admins'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets(
      'shows list of admins when state is SuperAdminAdminsListLoaded',
      (tester) async {
        // Arrange
        setCubitState(SuperAdminAdminsListLoaded(allAdmins: [tAdmin]));

        // Act
        await tester.pumpWidget(MaterialApp(home: buildTestWidget()));
        await tester.pump();

        // Assert
        expect(find.byType(PremiumAdminCard), findsOneWidget);
        expect(find.text('Admin User'), findsOneWidget);
        expect(find.text('admin@example.com'), findsOneWidget);
      },
    );

    testWidgets('should show empty state when list is empty', (tester) async {
      // Arrange
      setCubitState(const SuperAdminAdminsListLoaded(allAdmins: []));

      // Act
      await tester.pumpWidget(MaterialApp(home: buildTestWidget()));

      // Assert
      expect(find.text('No admins yet'), findsOneWidget);
      expect(find.byIcon(Icons.admin_panel_settings_outlined), findsOneWidget);
    });
  });
}
