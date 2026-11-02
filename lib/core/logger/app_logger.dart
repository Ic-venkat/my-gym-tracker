import 'package:logger/logger.dart';

/// App-wide logger instance that adheres to the no-print rule.
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    filter: DevelopmentFilter(),
    printer: PrettyPrinter(methodCount: 1),
  );

  /// Log debug messages.
  static void d(String message) {
    _logger.d(message);
  }

  /// Log informational messages.
  static void i(String message) {
    _logger.i(message);
  }

  /// Log warnings.
  static void w(String message) {
    _logger.w(message);
  }

  /// Log errors with optional error and stack trace.
  static void e(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
