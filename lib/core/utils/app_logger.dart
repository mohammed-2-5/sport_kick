import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:spo_kick/core/constants/app_constants.dart';

/// Lightweight, structured logger with optional ANSI colors and verbosity control.
class AppLogger {
  AppLogger._();

  static const _reset = '\x1B[0m';
  static const _colors = {
    _LogLevel.debug: '\x1B[36m', // cyan
    _LogLevel.info: '\x1B[32m', // green
    _LogLevel.warn: '\x1B[33m', // yellow
    _LogLevel.error: '\x1B[31m', // red
  };

  static bool get _useColors =>
      AppConstants.enableColoredLogs &&
      !kReleaseMode; // avoid color noise in release

  static bool get _verbose => AppConstants.enableVerboseLogs;

  static void debug(
    String message, {
    String tag = 'APP',
    bool verboseOnly = true,
  }) {
    if (verboseOnly && !_verbose) return;
    _log(_LogLevel.debug, tag, message);
  }

  static void info(String message, {String tag = 'APP'}) {
    _log(_LogLevel.info, tag, message);
  }

  static void warn(String message, {String tag = 'APP'}) {
    _log(_LogLevel.warn, tag, message);
  }

  static void error(
    String message, {
    String tag = 'APP',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(_LogLevel.error, tag, message, error: error, stackTrace: stackTrace);
  }

  static void _log(
    _LogLevel level,
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    final color = _useColors ? _colors[level] ?? '' : '';
    final reset = _useColors ? _reset : '';
    final line = '[$tag] $message';
    log(
      '$color${level.name.toUpperCase()} $line$reset',
      name: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

enum _LogLevel { debug, info, warn, error }
