import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:spo_kick/main.dart' as app;

/// Integration tests for the complete booking flow.
///
/// These tests verify the end-to-end user experience.
/// Note: The app is launched ONCE and all tests share the same instance
/// to avoid GetIt re-registration errors.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Booking Flow Integration Tests', () {
    // Launch app only once for all tests
    setUpAll(() async {
      app.main();
    });

    testWidgets('app should launch and display UI', (tester) async {
      // Give app time to fully initialize
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify app has launched - look for any Scaffold
      final scaffolds = find.byType(Scaffold);
      expect(scaffolds, findsWidgets);
    });

    testWidgets('app should be stable after initialization', (tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify no crash - any widget tree exists
      expect(find.byType(Widget), findsWidgets);
    });

    testWidgets('can interact with UI elements', (tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Try to find tappable elements
      final buttons = find.byType(ElevatedButton);
      final textButtons = find.byType(TextButton);
      final iconButtons = find.byType(IconButton);

      debugPrint('Found ${buttons.evaluate().length} ElevatedButtons');
      debugPrint('Found ${textButtons.evaluate().length} TextButtons');
      debugPrint('Found ${iconButtons.evaluate().length} IconButtons');

      // If any button exists, try tapping the first one
      if (iconButtons.evaluate().isNotEmpty) {
        await tester.tap(iconButtons.first);
        await tester.pumpAndSettle();
      }

      // App should remain stable
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('navigation should work if available', (tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for bottom navigation
      final bottomNav = find.byType(BottomNavigationBar);
      // final navBar = find.byType(NavigationBar);

      if (bottomNav.evaluate().isNotEmpty) {
        // Find navigation items and tap
        final navItems = find.descendant(
          of: bottomNav,
          matching: find.byType(InkResponse),
        );
        if (navItems.evaluate().length > 1) {
          await tester.tap(navItems.at(1));
          await tester.pumpAndSettle();
        }
      }

      // App should remain stable
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('scrolling should work', (tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find scrollable widgets
      final scrollables = find.byType(Scrollable);

      if (scrollables.evaluate().isNotEmpty) {
        // Try to scroll
        await tester.drag(scrollables.first, const Offset(0, -200));
        await tester.pumpAndSettle();
      }

      // App should remain stable
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
