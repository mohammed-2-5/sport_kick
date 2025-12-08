import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/auth/presentation/pages/profile_page.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  late MockAuthCubit mockAuthCubit;

  final tUser = UserEntity(
    id: 'user-1',
    email: 'test@example.com',
    fullName: 'Test User',
    role: 'user',
    createdAt: DateTime(2023, 1, 1),
    updatedAt: DateTime(2023, 1, 1),
    phone: '123456789',
  );

  setUp(() {
    mockAuthCubit = MockAuthCubit();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthCubit>.value(
        value: mockAuthCubit,
        child: const ProfilePage(),
      ),
    );
  }

  testWidgets('should show login message when unauthenticated', (tester) async {
    when(() => mockAuthCubit.state).thenReturn(const Unauthenticated());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Please login to view your profile'), findsOneWidget);
  });

  testWidgets('should show user details when authenticated', (tester) async {
    when(() => mockAuthCubit.state).thenReturn(Authenticated(tUser));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('USER'), findsOneWidget); // Role
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('123456789'), findsOneWidget);

    // Member since date format: Jan 1, 2023
    expect(find.text('Jan 1, 2023'), findsOneWidget);
  });

  testWidgets('should show Edit Profile and Logout buttons', (tester) async {
    when(() => mockAuthCubit.state).thenReturn(Authenticated(tUser));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });
}
