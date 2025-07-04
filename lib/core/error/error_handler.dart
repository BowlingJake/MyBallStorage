import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A global error handler that catches and logs Flutter and Dart errors.
class AppErrorHandler {
  /// Initializes the error handlers.
  ///
  /// This should be called in `main()` before `runApp()`.
  static void initialize() {
    // Catch errors from the Flutter framework.
    FlutterError.onError = _handleFlutterError;

    // Catch errors that occur outside the Flutter framework.
    // This is wrapped in a Zone.
    // PlatformDispatcher.instance.onError is an alternative for newer Flutter versions,
    // but runZonedGuarded is more robust for catching a wider range of async errors.
    // We will use runZonedGuarded in main.dart.
  }

  /// Custom handler for Flutter framework errors.
  static void _handleFlutterError(FlutterErrorDetails details) {
    if (kDebugMode) {
      // In debug mode, print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In release mode, you might report to a service like Sentry,
      // Firebase Crashlytics, etc.
      // For now, we'll just log that an error occurred.
      debugPrint('Caught a Flutter error: ${details.exception}');
    }
  }

  /// Custom handler for errors caught by runZonedGuarded.
  static void handleZonedError(Object error, StackTrace stack) {
    if (kDebugMode) {
      debugPrint('Caught an unhandled error: $error');
      debugPrint('Stack trace: \n$stack');
    } else {
      // In release mode, report to an error tracking service.
      debugPrint('Caught an unhandled error: $error');
    }
  }

  /// Wraps the app's root widget execution in a guarded zone.
  static void runGuarded(void Function() body) {
    runZonedGuarded(
      body,
      handleZonedError,
    );
  }
} 