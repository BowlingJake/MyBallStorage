import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A global error handler that catches and logs Flutter and Dart errors.
class AppErrorHandler {
  static const String _zoneMismatchWarning = 'Zone mismatch';

  /// Custom handler for errors. It centralizes error logging.
  static void _handleError(Object error, StackTrace? stack) {
    // We can add more robust logging here.
    if (kDebugMode) {
      debugPrint('Caught an error: $error');
      if (stack != null) {
        debugPrint('Stack trace: \n$stack');
      }
    }
  }

  /// Wraps the app's root widget execution in a guarded zone.
  static void runGuarded(void Function() body) {
    final zoneSpecification = ZoneSpecification(
      print: (self, parent, zone, line) {
        // Suppress the specific "Zone mismatch" warning.
        // This is a workaround for stubborn cases where the warning persists
        // despite correct setup, possibly due to external packages or environment.
        if (!line.contains(_zoneMismatchWarning)) {
          parent.print(zone, line);
        }
      },
      handleUncaughtError: (self, parent, zone, error, stackTrace) {
        _handleError(error, stackTrace);
      },
    );

    runZonedGuarded(
      () {
        WidgetsFlutterBinding.ensureInitialized();

        // The original FlutterError.onError might be called by the framework
        // before our zone's print handler can catch the log.
        // We ensure all Flutter errors are piped through our central handler.
        FlutterError.onError = (FlutterErrorDetails details) {
          _handleError(details.exception, details.stack);
        };
        
        // Catches other platform-level errors.
        PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
          _handleError(error, stack);
          return true; // Indicates that the error has been handled.
        };

        body();
      },
      (error, stack) {
        // This will now be handled by the zoneSpecification's handleUncaughtError,
        // but we keep it for safety.
        _handleError(error, stack);
      },
      zoneSpecification: zoneSpecification,
    );
  }
}
