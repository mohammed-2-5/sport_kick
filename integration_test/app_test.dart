import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'booking_flow_test.dart' as booking_flow;

/// Main test driver for integration tests.
///
/// Run with: flutter test integration_test
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('All Integration Tests', () {
    booking_flow.main();
  });
}
