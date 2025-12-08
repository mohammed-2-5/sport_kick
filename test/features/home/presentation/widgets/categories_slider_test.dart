import 'dart:async';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/observers/app_bloc_observer.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/home/presentation/widgets/categories_slider.dart';
import 'package:go_router/go_router.dart';

class MockFieldsCubit extends MockCubit<FieldsState> implements FieldsCubit {}

class MockGoRouter extends Mock implements GoRouter {}

// Mock HttpOverrides to handle Image.network
class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _TestHttpClient();
  }
}

class _TestHttpClient extends Mock implements HttpClient {
  _TestHttpClient() {
    registerFallbackValue((Uri uri) {});
    when(() => getUrl(any())).thenAnswer((_) async => _TestHttpClientRequest());
  }
}

class _TestHttpClientRequest extends Mock implements HttpClientRequest {
  _TestHttpClientRequest() {
    when(() => close()).thenAnswer((_) async => _TestHttpClientResponse());
  }
}

class _TestHttpClientResponse extends Mock implements HttpClientResponse {
  _TestHttpClientResponse() {
    when(() => statusCode).thenReturn(200);
    when(() => contentLength).thenReturn(0);
    when(
      () => compressionState,
    ).thenReturn(HttpClientResponseCompressionState.notCompressed);
    when(
      () => listen(
        any(),
        onDone: any(named: 'onDone'),
        onError: any(named: 'onError'),
        cancelOnError: any(named: 'cancelOnError'),
      ),
    ).thenAnswer((invocation) {
      final void Function() onDone = invocation.namedArguments[#onDone];
      onDone();
      return _TestStreamSubscription();
    });
  }
}

class _TestStreamSubscription extends Mock
    implements StreamSubscription<List<int>> {}

void main() {
  late MockFieldsCubit mockFieldsCubit;
  late MockGoRouter mockGoRouter;

  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  setUp(() {
    Bloc.observer = const AppBlocObserver();
    mockFieldsCubit = MockFieldsCubit();
    mockGoRouter = MockGoRouter();

    // Default state: Empty
    when(() => mockFieldsCubit.state).thenReturn(const FieldsInitial());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: InheritedGoRouter(
        goRouter: mockGoRouter,
        child: BlocProvider<FieldsCubit>.value(
          value: mockFieldsCubit,
          child: const Scaffold(body: CategoriesSlider()),
        ),
      ),
    );
  }

  testWidgets(
    'CategoriesSlider displays mock categories when state has no data',
    (tester) async {
      when(
        () => mockFieldsCubit.state,
      ).thenReturn(const FieldsLoaded(fields: [], categories: []));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Should show Football, Tennis, etc. from mock data
      expect(find.text('Football'), findsOneWidget);
      expect(find.text('Tennis'), findsOneWidget);
    },
  );

  testWidgets('CategoriesSlider displays real categories when state has data', (
    tester,
  ) async {
    final categories = [
      SportCategoryEntity(
        id: 'cat1',
        name: 'Real Football',
        createdAt: DateTime.now(),
      ),
      SportCategoryEntity(
        id: 'cat2',
        name: 'Real Tennis',
        createdAt: DateTime.now(),
      ),
    ];
    when(
      () => mockFieldsCubit.state,
    ).thenReturn(FieldsLoaded(fields: const [], categories: categories));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Should show Real Football
    expect(find.text('Real Football'), findsOneWidget);
    // Should NOT show mock "Football" (unless name matches, but here we used "Real Football")
    expect(find.text('Football'), findsNothing);
  });

  testWidgets('Tapping a category navigates to fieldsList with categoryId', (
    tester,
  ) async {
    final categories = [
      SportCategoryEntity(
        id: 'cat123',
        name: 'Soccer',
        createdAt: DateTime.now(),
      ),
    ];
    when(
      () => mockFieldsCubit.state,
    ).thenReturn(FieldsLoaded(fields: const [], categories: categories));

    await tester.pumpWidget(createWidgetUnderTest());
    // Initial pump
    await tester.pumpAndSettle();

    final soccerTextFinder = find.text('Soccer');
    expect(soccerTextFinder, findsOneWidget);

    // Find the GestureDetector that contains this text
    final gestureDetectorFinder = find.ancestor(
      of: soccerTextFinder,
      matching: find.byType(GestureDetector),
    );

    await tester.ensureVisible(gestureDetectorFinder);
    await tester.tap(gestureDetectorFinder);
    await tester.pump(const Duration(milliseconds: 500));

    // Verify navigation
    verify(
      () => mockGoRouter.pushNamed('fieldsList', extra: any(named: 'extra')),
    ).called(1);
  });
}
