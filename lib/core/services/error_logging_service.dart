import 'package:flutter/foundation.dart';

/// Centralized Error Logging Service
///
/// Provides consistent error logging across the application.
/// In production, this can be connected to crash reporting services
/// like Firebase Crashlytics, Sentry, or custom logging backends.
class ErrorLoggingService {
  static final ErrorLoggingService _instance = ErrorLoggingService._internal();

  factory ErrorLoggingService() => _instance;

  ErrorLoggingService._internal();

  /// Log an error with optional stack trace and additional context
  void logError(
    Object error, {
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? additionalData,
    ErrorSeverity severity = ErrorSeverity.error,
  }) {
    // In development mode, print to console
    if (kDebugMode) {
      _logToConsole(error, stackTrace, context, additionalData, severity);
    }

    // In production, send to crash reporting service
    if (kReleaseMode) {
      _logToRemoteService(error, stackTrace, context, additionalData, severity);
    }

    // Log to local storage for offline debugging
    _logToLocalStorage(error, stackTrace, context, additionalData, severity);
  }

  /// Log informational message
  void logInfo(String message, {Map<String, dynamic>? data}) {
    logError(
      message,
      context: 'Info',
      additionalData: data,
      severity: ErrorSeverity.info,
    );
  }

  /// Log warning
  void logWarning(String message, {Map<String, dynamic>? data}) {
    logError(
      message,
      context: 'Warning',
      additionalData: data,
      severity: ErrorSeverity.warning,
    );
  }

  /// Log fatal error
  void logFatal(
    Object error, {
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? additionalData,
  }) {
    logError(
      error,
      stackTrace: stackTrace,
      context: context,
      additionalData: additionalData,
      severity: ErrorSeverity.fatal,
    );
  }

  /// Log network error
  void logNetworkError(
    Object error, {
    String? endpoint,
    int? statusCode,
    Map<String, dynamic>? requestData,
  }) {
    logError(
      error,
      context: 'Network Error',
      additionalData: {
        'endpoint': endpoint,
        'statusCode': statusCode,
        ...?requestData,
      },
      severity: ErrorSeverity.error,
    );
  }

  /// Log authentication error
  void logAuthError(Object error, {String? userId, String? action}) {
    logError(
      error,
      context: 'Authentication Error',
      additionalData: {'userId': userId, 'action': action},
      severity: ErrorSeverity.error,
    );
  }

  /// Log to console for development
  void _logToConsole(
    Object error,
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? additionalData,
    ErrorSeverity severity,
  ) {
    final buffer = StringBuffer();
    buffer.writeln(
      '╔════════════════════════════════════════════════════════════',
    );
    buffer.writeln('║ ERROR LOG [${severity.name.toUpperCase()}]');
    buffer.writeln(
      '╠════════════════════════════════════════════════════════════',
    );

    if (context != null) {
      buffer.writeln('║ Context: $context');
    }

    buffer.writeln('║ Error: $error');

    if (additionalData != null && additionalData.isNotEmpty) {
      buffer.writeln('║ Additional Data:');
      additionalData.forEach((key, value) {
        buffer.writeln('║   $key: $value');
      });
    }

    if (stackTrace != null) {
      buffer.writeln('║ Stack Trace:');
      final stackLines = stackTrace.toString().split('\n');
      for (var line in stackLines.take(10)) {
        buffer.writeln('║   $line');
      }
      if (stackLines.length > 10) {
        buffer.writeln('║   ... (${stackLines.length - 10} more lines)');
      }
    }

    buffer.writeln(
      '╚════════════════════════════════════════════════════════════',
    );

    debugPrint(buffer.toString());
  }

  /// Log to remote service (Firebase Crashlytics, Sentry, etc.)
  void _logToRemoteService(
    Object error,
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? additionalData,
    ErrorSeverity severity,
  ) {
    // TODO: Implement Firebase Crashlytics for production error tracking
    //
    // Setup Steps:
    // 1. Add dependencies to pubspec.yaml:
    //    dependencies:
    //      firebase_core: ^3.10.0
    //      firebase_crashlytics: ^4.2.0
    //
    // 2. Add Firebase configuration files:
    //    - Android: android/app/google-services.json
    //    - iOS: ios/Runner/GoogleService-Info.plist
    //
    // 3. Initialize Firebase in main.dart:
    //    await Firebase.initializeApp(
    //      options: DefaultFirebaseOptions.currentPlatform,
    //    );
    //
    // 4. Enable Crashlytics in main.dart:
    //    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    //    PlatformDispatcher.instance.onError = (error, stack) {
    //      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    //      return true;
    //    };
    //
    // 5. Uncomment the code below:
    //
    // try {
    //   // Set custom keys for additional context
    //   if (context != null) {
    //     FirebaseCrashlytics.instance.setCustomKey('context', context);
    //   }
    //   if (additionalData != null) {
    //     for (var entry in additionalData.entries) {
    //       FirebaseCrashlytics.instance.setCustomKey(
    //         entry.key,
    //         entry.value.toString(),
    //       );
    //     }
    //   }
    //
    //   // Record the error
    //   FirebaseCrashlytics.instance.recordError(
    //     error,
    //     stackTrace,
    //     reason: context,
    //     fatal: severity == ErrorSeverity.fatal,
    //   );
    // } catch (e) {
    //   debugPrint('[Crashlytics Error] Failed to log: $e');
    // }

    debugPrint('[Remote Logging Placeholder] Error logged: $error');
  }

  /// Log to local storage for offline debugging
  void _logToLocalStorage(
    Object error,
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? additionalData,
    ErrorSeverity severity,
  ) {
    // TODO: Implement local logging to file or database
    // This can be useful for debugging issues that occur offline
    // or for providing detailed logs when user reports a problem

    // Example implementation:
    // - Store in SQLite database
    // - Write to log file
    // - Keep last N errors in memory

    debugPrint('[Local Storage Placeholder] Error logged: $error');
  }

  /// Clear old logs (maintenance function)
  Future<void> clearOldLogs({int daysToKeep = 7}) async {
    // TODO: Implement log cleanup for local storage
    debugPrint('[Log Cleanup] Clearing logs older than $daysToKeep days');
  }

  /// Get recent logs for debugging (development only)
  Future<List<ErrorLogEntry>> getRecentLogs({int limit = 50}) async {
    // TODO: Implement retrieval of recent logs from local storage
    debugPrint('[Log Retrieval] Getting recent $limit logs');
    return [];
  }
}

/// Error severity levels
enum ErrorSeverity { info, warning, error, fatal }

/// Error log entry model
class ErrorLogEntry {
  final DateTime timestamp;
  final String error;
  final String? stackTrace;
  final String? context;
  final Map<String, dynamic>? additionalData;
  final ErrorSeverity severity;

  ErrorLogEntry({
    required this.timestamp,
    required this.error,
    this.stackTrace,
    this.context,
    this.additionalData,
    required this.severity,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'error': error,
    'stackTrace': stackTrace,
    'context': context,
    'additionalData': additionalData,
    'severity': severity.name,
  };

  factory ErrorLogEntry.fromJson(Map<String, dynamic> json) => ErrorLogEntry(
    timestamp: DateTime.parse(json['timestamp'] as String),
    error: json['error'] as String,
    stackTrace: json['stackTrace'] as String?,
    context: json['context'] as String?,
    additionalData: json['additionalData'] as Map<String, dynamic>?,
    severity: ErrorSeverity.values.firstWhere(
      (e) => e.name == json['severity'],
      orElse: () => ErrorSeverity.error,
    ),
  );
}
