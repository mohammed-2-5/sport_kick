import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/utils/search_history.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/search_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/search_state.dart';

// Mocks
class MockFieldsCubit extends Mock implements FieldsCubit {}

class MockSearchHistoryService extends Mock implements SearchHistoryService {}

void main() {
  late SearchCubit cubit;
  late MockFieldsCubit mockFieldsCubit;
  late MockSearchHistoryService mockHistoryService;

  setUp(() {
    mockFieldsCubit = MockFieldsCubit();
    mockHistoryService = MockSearchHistoryService();

    // Setup default mock responses
    when(() => mockHistoryService.getHistory()).thenAnswer((_) async => []);
    when(() => mockHistoryService.addToHistory(any())).thenAnswer((_) async {});
    when(
      () => mockHistoryService.removeFromHistory(any()),
    ).thenAnswer((_) async {});
    when(() => mockHistoryService.clearHistory()).thenAnswer((_) async {});

    cubit = SearchCubit(
      fieldsCubit: mockFieldsCubit,
      historyService: mockHistoryService,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('SearchCubit -', () {
    test('initial state should be SearchInitial', () {
      expect(cubit.state, equals(const SearchInitial()));
    });

    group('loadHistory -', () {
      test(
        'should emit SearchHistoryLoaded with history from service',
        () async {
          when(
            () => mockHistoryService.getHistory(),
          ).thenAnswer((_) async => ['query1', 'query2']);

          await cubit.loadHistory();

          expect(cubit.state, isA<SearchHistoryLoaded>());
          expect((cubit.state as SearchHistoryLoaded).history, [
            'query1',
            'query2',
          ]);
          verify(() => mockHistoryService.getHistory()).called(1);
        },
      );
    });

    group('search -', () {
      test('should not search when query is empty', () async {
        cubit.search('');

        await Future.delayed(const Duration(milliseconds: 600));

        verifyNever(() => mockFieldsCubit.searchFields(any()));
      });

      test('should not search when query is only whitespace', () async {
        cubit.search('   ');

        await Future.delayed(const Duration(milliseconds: 600));

        verifyNever(() => mockFieldsCubit.searchFields(any()));
      });
    });

    group('submitSearch -', () {
      test('should call fieldsCubit.searchFields and add to history', () async {
        when(
          () => mockFieldsCubit.searchFields(any()),
        ).thenAnswer((_) async {});

        await cubit.submitSearch('test query');

        verify(() => mockHistoryService.addToHistory('test query')).called(1);
        verify(() => mockFieldsCubit.searchFields('test query')).called(1);
        verify(() => mockHistoryService.getHistory()).called(1);
      });

      test('should not search when query is empty', () async {
        await cubit.submitSearch('');

        verifyNever(() => mockFieldsCubit.searchFields(any()));
        verifyNever(() => mockHistoryService.addToHistory(any()));
      });

      test('should not search when query is whitespace only', () async {
        await cubit.submitSearch('   ');

        verifyNever(() => mockFieldsCubit.searchFields(any()));
        verifyNever(() => mockHistoryService.addToHistory(any()));
      });
    });

    group('selectHistoryItem -', () {
      test('should add to history and search', () async {
        when(
          () => mockFieldsCubit.searchFields(any()),
        ).thenAnswer((_) async {});

        await cubit.selectHistoryItem('history item');

        verify(() => mockHistoryService.addToHistory('history item')).called(1);
        verify(() => mockFieldsCubit.searchFields('history item')).called(1);
      });
    });

    group('removeFromHistory -', () {
      test('should call service and reload history', () async {
        await cubit.removeFromHistory('old query');

        verify(
          () => mockHistoryService.removeFromHistory('old query'),
        ).called(1);
        verify(() => mockHistoryService.getHistory()).called(1);
      });
    });

    group('clearHistory -', () {
      test('should clear all history and reload', () async {
        await cubit.clearHistory();

        verify(() => mockHistoryService.clearHistory()).called(1);
        verify(() => mockHistoryService.getHistory()).called(1);
      });
    });

    group('onCityChanged -', () {
      test('should call fieldsCubit.setCurrentCity', () {
        when(
          () => mockFieldsCubit.setCurrentCity(any()),
        ).thenAnswer((_) async {});

        cubit.onCityChanged('city-123');

        verify(() => mockFieldsCubit.setCurrentCity('city-123')).called(1);
      });
    });

    group('close -', () {
      test('should cancel debounce timer on close', () async {
        cubit.search('test');

        await cubit.close();

        await Future.delayed(const Duration(milliseconds: 600));

        verifyNever(() => mockFieldsCubit.searchFields(any()));
      });
    });
  });
}
