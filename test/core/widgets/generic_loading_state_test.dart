import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spo_kick/core/widgets/generic_loading_state.dart';

void main() {
  group('GenericLoadingState', () {
    testWidgets('displays default loading message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GenericLoadingState(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('displays custom loading message', (tester) async {
      const customMessage = 'Loading users...';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GenericLoadingState(message: customMessage),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(customMessage), findsOneWidget);
    });

    testWidgets('centers content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GenericLoadingState(),
          ),
        ),
      );

      final center = tester.widget<Center>(find.byType(Center));
      expect(center, isNotNull);
    });
  });
}
