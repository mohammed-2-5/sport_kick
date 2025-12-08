import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_state.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/fields_list_view.dart';
import 'package:spo_kick/features/fields/presentation/widgets/field_filters_dialog.dart';

// Mocks
class MockFieldsCubit extends MockCubit<FieldsState> implements FieldsCubit {}

class MockCityCubit extends MockCubit<CityState> implements CityCubit {}

// Helper to mock Cubit stream (since MockCubit handles it, we don't need complex overrides)

void main() {
  late MockFieldsCubit mockFieldsCubit;
  late MockCityCubit mockCityCubit;

  setUpAll(() {
    registerFallbackValue(const FieldFilterOptions());
  });

  final tFields = [
    FieldEntity(
      id: '1',
      name: 'Alpha Field',
      sportCategoryId: 'cat1',
      city: 'Cairo',
      pricePerHour: 100,
      isIndoor: true,
      isVerified: true,
      address: '123 St',
      ownerId: 'o1',
      currency: 'EGP',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    FieldEntity(
      id: '2',
      name: 'Beta Field',
      sportCategoryId: 'cat2',
      city: 'Cairo',
      pricePerHour: 200,
      isIndoor: false,
      isVerified: false,
      address: '456 St',
      ownerId: 'o2',
      currency: 'EGP',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  final tCategories = [
    SportCategoryEntity(
      id: 'cat1',
      name: 'Football',
      isActive: true,
      createdAt: DateTime.now(),
      icon: '',
    ),
    SportCategoryEntity(
      id: 'cat2',
      name: 'Basketball',
      isActive: true,
      createdAt: DateTime.now(),
      icon: '',
    ),
  ];

  setUp(() {
    mockFieldsCubit = MockFieldsCubit();
    mockCityCubit = MockCityCubit();

    // Default stubs
    when(() => mockCityCubit.state).thenReturn(const CityInitial());
    when(() => mockCityCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockCityCubit.loadCities()).thenAnswer((_) async {});

    // Default Fields State: Loaded with all fields
    when(
      () => mockFieldsCubit.state,
    ).thenReturn(FieldsLoaded(fields: tFields, categories: tCategories));
    when(() => mockFieldsCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FieldsCubit>.value(value: mockFieldsCubit),
        BlocProvider<CityCubit>.value(value: mockCityCubit),
      ],
      child: const MaterialApp(home: FieldsListView()),
    );
  }

  group('Fields Flow Reality Test', () {
    testWidgets('Search "Alpha" updates list', (tester) async {
      final initialState = FieldsLoaded(
        fields: tFields,
        categories: tCategories,
        searchQuery: null,
      );
      final filteredState = FieldsLoaded(
        fields: tFields,
        categories: tCategories,
        searchQuery: 'Alpha',
      );

      final controller = StreamController<FieldsState>.broadcast();
      addTearDown(controller.close);

      when(() => mockFieldsCubit.state).thenReturn(initialState);
      when(() => mockFieldsCubit.stream).thenAnswer((_) => controller.stream);

      controller.add(initialState);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Act: Search for "Alpha"
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Alpha');
      await tester.testTextInput.receiveAction(TextInputAction.done);

      // Simulate Cubit emitting new state with searchQuery
      // (Widget doesn't wait for real logic, we must mock state change response)
      // The search logic calls `searchFields('Alpha')`.
      verify(() => mockFieldsCubit.searchFields('Alpha')).called(1);

      controller.add(filteredState);
      when(() => mockFieldsCubit.state).thenReturn(filteredState);
      await tester.pumpAndSettle();

      expect(find.text('Alpha Field'), findsOneWidget);
      expect(find.text('Beta Field'), findsNothing);
    });

    testWidgets('Filter Dialog updates options', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Act: Open Filters
      final filterBtn = find.byIcon(
        Icons.tune,
      ); // Assuming 'tune' icon or similar for filter
      // If icon is different, find by type IconButton
      await tester.tap(filterBtn);
      await tester.pumpAndSettle();

      expect(find.byType(FieldFiltersDialog), findsOneWidget);

      // Select "Indoor"
      await tester.tap(find.text('Indoor'));

      // Apply
      await tester.tap(find.text('Apply Filters'));
      await tester.pumpAndSettle();

      // Verify `applyFilters` called with correct options
      final captured = verify(
        () => mockFieldsCubit.applyFilters(captureAny()),
      ).captured;
      final options = captured.last as FieldFilterOptions;
      expect(options.isIndoor, true);
    });
  });
}
