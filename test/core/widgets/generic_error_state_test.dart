import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spo_kick/core/widgets/generic_error_state.dart';

void main() {
  group('GenericErrorState', () {
    testWidgets('displays error message and retry button', (tester) async {
      const errorMessage = 'Failed to load data';
      var retryPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenericErrorState(
              message: errorMessage,
              onRetry: () => retryPressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Error'), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      expect(retryPressed, isTrue);
    });

    testWidgets('displays custom title', (tester) async {
      const customTitle = 'Error loading users';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenericErrorState(
              message: 'Something went wrong',
              onRetry: () {},
              title: customTitle,
            ),
          ),
        ),
      );

      expect(find.text(customTitle), findsOneWidget);
    });

    testWidgets('displays custom icon and color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GenericErrorState(
              message: 'Error',
              onRetry: null,
              icon: Icons.warning,
              iconColor: Colors.orange,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.warning), findsOneWidget);
      
      final icon = tester.widget<Icon>(find.byIcon(Icons.warning));
      expect(icon.color, Colors.orange);
    });

    testWidgets('displays custom retry text', (tester) async {
      const customRetryText = 'Try Again';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenericErrorState(
              message: 'Error',
              onRetry: () {},
              retryText: customRetryText,
            ),
          ),
        ),
      );

      expect(find.text(customRetryText), findsOneWidget);
    });
  });
}
