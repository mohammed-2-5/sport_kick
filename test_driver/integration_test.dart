import 'package:integration_test/integration_test_driver.dart';

/// Main entry point for running integration tests via `flutter drive`.
///
/// Usage:
///   flutter drive --driver=test_driver/integration_test.dart \
///                 --target=integration_test/booking_flow_test.dart
///
/// Or for all tests:
///   flutter drive --driver=test_driver/integration_test.dart \
///                 --target=integration_test/app_test.dart
Future<void> main() => integrationDriver();
