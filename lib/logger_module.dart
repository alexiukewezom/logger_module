library logger_module;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class LoggerModule {
  final Logger _logger;
  final Function(String message) _onHandleError;

  LoggerModule({
    Logger? logger,
    required Function(String message) onHandleError,
  })  : _logger = logger ?? Logger(),
        _onHandleError = onHandleError;

  static LoggerModule get module => Get.find<LoggerModule>();

  void log(
    dynamic message, {
    Level level = Level.verbose,
    dynamic error,
    StackTrace? stackTrace,
    bool showMessage = false,
    dynamic payload,
  }) {
    switch (level) {
      case Level.verbose:
        return _logger.v(message);
      case Level.debug:
        return _logger.d(message);
      case Level.info:
        return _logger.i(message);
      case Level.warning:
        return _logger.w(message);
      case Level.error:
        if (showMessage) _onHandleError(message.toString());
        FirebaseCrashlytics.instance.recordError(
          message,
          stackTrace,
          reason: ' in $payload',
        );
        return _logger.e(message, error, stackTrace);
      case Level.wtf:
        return;
      case Level.nothing:
        return;
    }
  }
}
