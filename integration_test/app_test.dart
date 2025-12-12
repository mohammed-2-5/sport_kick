import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Import individual test files
// Note: Only run ONE test file at a time or use a test driver to avoid
// GetIt re-registration issues.
import 'booking_flow_test.dart' as booking_flow;

/// Main integration test driver.
///
/// Run with: flutter test integration_test/app_test.dart
///
/// Or run individual tests:
///   flutter test integration_test/booking_flow_test.dart
///   flutter test integration_test/auth_flow_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Run booking flow tests
  booking_flow.main();

  // Note: Cannot run auth_flow tests in the same run due to app reinitialization
  // Run separately: flutter test integration_test/auth_flow_test.dart
}
