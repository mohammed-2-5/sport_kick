import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spo_kick/core/widgets/generic_empty_state.dart';

void main() {
  group('GenericEmptyState', () {
    testWidgets('displays empty state without filters', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GenericEmptyState(
              hasFilters: false,
              emptyTitle: 'No Items',
              filteredTitle: 'No Results',
              emptySubtitle: 'Items will appear here',
              filteredSubtitle: 'Try adjusting filters',
            ),
          ),
        ),
      );

      expect(find.text('No Items'), findsOneWidget);
      expect(find.text('Items will appear here'), findsOneWidget);
      expect(find.text('No Results'), findsNothing);
      expect(find.text('Try adjusting filters'), findsNothing);
    });

    testWidgets('displays filtered empty state', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GenericEmptyState(
              hasFilters: true,
              emptyTitle: 'No Items',
              filteredTitle: 'No Results',
              emptySubtitle: 'Items will appear here',
              filteredSubtitle: 'Try adjusting filters',
            ),
          ),
        ),
      );

      expect(find.text('No Results'), findsOneWidget);
      expect(find.text('Try adjusting filters'), findsOneWidget);
      expect(find.text('No Items'), findsNothing);
      expect(find.text('Items will appear here'), findsNothing);
    });

    testWidgets('displays custom icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GenericEmptyState(
              hasFilters: false,
              icon: Icons.sports_soccer,
              emptyTitle: 'No Fields',
              filteredTitle: 'No Results',
              emptySubtitle: 'Fields will appear here',
              filteredSubtitle: 'Try adjusting filters',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.sports_soccer), findsOneWidget);
    });

    testWidgets('uses default icon based on hasFilters', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GenericEmptyState(
              hasFilters: true,
              emptyTitle: 'No Items',
              filteredTitle: 'No Results',
              emptySubtitle: 'Items will appear here',
              filteredSubtitle: 'Try adjusting filters',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('centers content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GenericEmptyState(
              hasFilters: false,
              emptyTitle: 'No Items',
              filteredTitle: 'No Results',
              emptySubtitle: 'Items will appear here',
              filteredSubtitle: 'Try adjusting filters',
            ),
          ),
        ),
      );

      final center = tester.widget<Center>(find.byType(Center));
      expect(center, isNotNull);
    });
  });
}
