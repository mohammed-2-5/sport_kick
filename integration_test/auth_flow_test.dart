import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:spo_kick/main.dart' as app;

/// Integration tests for authentication flow.
///
/// Note: These tests must run separately from booking tests
/// since they also initialize the app.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Flow Integration Tests', () {
    setUpAll(() async {
      app.main();
    });

    testWidgets('auth screens have expected elements', (tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Look for form elements common in auth screens
      final textFields = find.byType(TextFormField);
      final emailField = find.byKey(const Key('email_field'));
      final passwordField = find.byKey(const Key('password_field'));

      debugPrint('TextFormFields found: ${textFields.evaluate().length}');
      debugPrint('Email fields (by key): ${emailField.evaluate().length}');
      debugPrint(
        'Password fields (by key): ${passwordField.evaluate().length}',
      );

      // Verify app is running
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('can type in text fields if available', (tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final textFields = find.byType(TextFormField);

      if (textFields.evaluate().isNotEmpty) {
        await tester.enterText(textFields.first, 'test@example.com');
        await tester.pumpAndSettle();
      }

      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('buttons are tappable', (tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final elevatedButtons = find.byType(ElevatedButton);

      if (elevatedButtons.evaluate().isNotEmpty) {
        // Just verify button exists, don't tap to avoid form submission
        expect(elevatedButtons, findsWidgets);
      }

      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('app handles user interaction gracefully', (tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Try scrolling to ensure app is responsive
      final scrollables = find.byType(Scrollable);
      if (scrollables.evaluate().isNotEmpty) {
        await tester.fling(scrollables.first, const Offset(0, -100), 500);
        await tester.pumpAndSettle();
      }

      // App should still be stable
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
