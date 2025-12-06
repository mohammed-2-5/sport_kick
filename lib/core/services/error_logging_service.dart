import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Centralized Error Logging Service
///
/// Provides consistent error logging across the application.
/// Integrated with Firebase Crashlytics for production error tracking.
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

  /// Log to remote service (Firebase Crashlytics)
  void _logToRemoteService(
    Object error,
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? additionalData,
    ErrorSeverity severity,
  ) {
    try {
      // Set custom keys for additional context
      if (context != null) {
        FirebaseCrashlytics.instance.setCustomKey('context', context);
      }

      // Set severity level
      FirebaseCrashlytics.instance.setCustomKey('severity', severity.name);

      // Add all additional data as custom keys
      if (additionalData != null) {
        for (var entry in additionalData.entries) {
          FirebaseCrashlytics.instance.setCustomKey(
            entry.key,
            entry.value.toString(),
          );
        }
      }

      // Record the error to Crashlytics
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: context,
        fatal: severity == ErrorSeverity.fatal,
      );

      debugPrint('[Crashlytics] Error logged successfully');
    } catch (e) {
      debugPrint('[Crashlytics Error] Failed to log error: $e');
    }
  }

  /// Log to local storage for offline debugging
  Future<void> _logToLocalStorage(
    Object error,
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? additionalData,
    ErrorSeverity severity,
  ) async {
    try {
      // Open error logs box (lazy initialization)
      if (!Hive.isBoxOpen('error_logs')) {
        await Hive.openBox<Map>('error_logs');
      }

      final box = Hive.box<Map>('error_logs');

      // Create log entry
      final logEntry = ErrorLogEntry(
        timestamp: DateTime.now(),
        error: error.toString(),
        stackTrace: stackTrace?.toString(),
        context: context,
        additionalData: additionalData,
        severity: severity,
      );

      // Store in Hive (keep last 100 entries to avoid excessive storage)
      await box.add(logEntry.toJson());

      // Clean up old entries if box exceeds limit
      if (box.length > 100) {
        final keysToDelete = box.keys.take(box.length - 100).toList();
        await box.deleteAll(keysToDelete);
      }

      debugPrint('[Local Storage] Error logged successfully');
    } catch (e) {
      debugPrint('[Local Storage Error] Failed to log: $e');
    }
  }

  /// Clear old logs (maintenance function)
  Future<void> clearOldLogs({int daysToKeep = 7}) async {
    try {
      if (!Hive.isBoxOpen('error_logs')) {
        await Hive.openBox<Map>('error_logs');
      }

      final box = Hive.box<Map>('error_logs');
      final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));

      // Find and delete old entries
      final keysToDelete = <dynamic>[];
      for (var key in box.keys) {
        final logData = box.get(key);
        if (logData != null && logData['timestamp'] != null) {
          final timestamp = DateTime.parse(logData['timestamp'] as String);
          if (timestamp.isBefore(cutoffDate)) {
            keysToDelete.add(key);
          }
        }
      }

      await box.deleteAll(keysToDelete);
      debugPrint(
        '[Log Cleanup] Cleared ${keysToDelete.length} logs older than $daysToKeep days',
      );
    } catch (e) {
      debugPrint('[Log Cleanup Error] Failed to clear logs: $e');
    }
  }

  /// Get recent logs for debugging (development only)
  Future<List<ErrorLogEntry>> getRecentLogs({int limit = 50}) async {
    try {
      if (!Hive.isBoxOpen('error_logs')) {
        await Hive.openBox<Map>('error_logs');
      }

      final box = Hive.box<Map>('error_logs');
      final logs = <ErrorLogEntry>[];

      // Get logs in reverse order (most recent first)
      final keys = box.keys.toList().reversed.take(limit);
      for (var key in keys) {
        final logData = box.get(key);
        if (logData != null) {
          try {
            final log = ErrorLogEntry.fromJson(
              Map<String, dynamic>.from(logData),
            );
            logs.add(log);
          } catch (e) {
            debugPrint('[Log Retrieval] Failed to parse log entry: $e');
          }
        }
      }

      debugPrint('[Log Retrieval] Retrieved ${logs.length} recent logs');
      return logs;
    } catch (e) {
      debugPrint('[Log Retrieval Error] Failed to get logs: $e');
      return [];
    }
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
