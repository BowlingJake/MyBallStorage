import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';

/// Mixin for standardized error handling in Arsenal feature
mixin ArsenalErrorHandlingMixin {
  /// Handle Arsenal-specific errors with context-aware messages
  void handleArsenalError(
    BuildContext context, 
    String operation, 
    dynamic error, {
    String? customMessage,
  }) {
    final String errorMessage = customMessage ?? _getErrorMessage(operation, error);
    
    TopNotification.showError(context, errorMessage);
    
    // Log error for debugging (in production, this would go to a logging service)
    debugPrint('Arsenal Error in $operation: $error');
  }

  /// Handle async Arsenal operations with standardized error handling
  Future<T?> handleArsenalOperation<T>(
    BuildContext context,
    String operationName,
    Future<T> operation, {
    String? successMessage,
    Function(T)? onSuccess,
    Function(dynamic)? onError,
  }) async {
    try {
      final result = await operation;
      
      // Show success message if provided
      if (successMessage != null) {
        TopNotification.showSuccess(context, successMessage);
      }
      
      // Execute success callback if provided
      onSuccess?.call(result);
      
      return result;
    } catch (error) {
      // Execute error callback if provided
      onError?.call(error);
      
      // Handle error with context-aware message
      handleArsenalError(context, operationName, error);
      
      return null;
    }
  }

  /// Handle validation errors specific to Arsenal operations
  void handleValidationError(
    BuildContext context,
    String field,
    String validationMessage,
  ) {
    TopNotification.showError(
      context,
      'Validation Error: $validationMessage',
    );
  }

  /// Handle network/connectivity errors
  void handleNetworkError(
    BuildContext context,
    String operation,
  ) {
    TopNotification.showError(
      context,
      'Network error during $operation. Please check your connection and try again.',
    );
  }

  /// Handle authentication errors
  void handleAuthError(
    BuildContext context,
    String operation,
  ) {
    TopNotification.showError(
      context,
      'Authentication required for $operation. Please log in and try again.',
    );
  }

  /// Handle permission errors
  void handlePermissionError(
    BuildContext context,
    String operation,
  ) {
    TopNotification.showError(
      context,
      'Permission denied for $operation. Please check your account permissions.',
    );
  }

  /// Get context-aware error message based on operation and error type
  String _getErrorMessage(String operation, dynamic error) {
    final String errorStr = error.toString().toLowerCase();
    
    // Network-related errors
    if (errorStr.contains('network') || 
        errorStr.contains('connection') || 
        errorStr.contains('timeout')) {
      return 'Network error during $operation. Please check your connection.';
    }
    
    // Authentication errors
    if (errorStr.contains('auth') || 
        errorStr.contains('unauthorized') || 
        errorStr.contains('login')) {
      return 'Authentication required for $operation. Please log in.';
    }
    
    // Permission errors
    if (errorStr.contains('permission') || 
        errorStr.contains('forbidden') || 
        errorStr.contains('access denied')) {
      return 'Permission denied for $operation. Check your account permissions.';
    }
    
    // Validation errors
    if (errorStr.contains('validation') || 
        errorStr.contains('invalid') || 
        errorStr.contains('required')) {
      return 'Invalid data for $operation. Please check your input.';
    }
    
    // Database/storage errors
    if (errorStr.contains('database') || 
        errorStr.contains('storage') || 
        errorStr.contains('save') || 
        errorStr.contains('load')) {
      return 'Data error during $operation. Please try again.';
    }
    
    // Arsenal-specific errors
    if (errorStr.contains('bag')) {
      return 'Bag operation failed: ${_extractBagErrorMessage(errorStr)}';
    }
    
    if (errorStr.contains('ball')) {
      return 'Ball operation failed: ${_extractBallErrorMessage(errorStr)}';
    }
    
    // Generic error message
    return 'An error occurred during $operation. Please try again.';
  }

  /// Extract bag-specific error messages
  String _extractBagErrorMessage(String errorStr) {
    if (errorStr.contains('locked')) {
      return 'Bag is locked. Please unlock it first.';
    }
    if (errorStr.contains('full')) {
      return 'Bag is full. Remove some balls first.';
    }
    if (errorStr.contains('not found')) {
      return 'Bag not found or unavailable.';
    }
    return 'Unknown bag error.';
  }

  /// Extract ball-specific error messages
  String _extractBallErrorMessage(String errorStr) {
    if (errorStr.contains('duplicate')) {
      return 'Ball already exists in your arsenal.';
    }
    if (errorStr.contains('not found')) {
      return 'Ball not found in your arsenal.';
    }
    if (errorStr.contains('move')) {
      return 'Cannot move ball to the selected bag.';
    }
    return 'Unknown ball error.';
  }
}

/// Arsenal error categories for better error classification
enum ArsenalErrorCategory {
  network,
  authentication,
  permission,
  validation,
  storage,
  bagOperation,
  ballOperation,
  unknown,
}

/// Arsenal error details for comprehensive error information
class ArsenalErrorDetails {
  final ArsenalErrorCategory category;
  final String operation;
  final String message;
  final dynamic originalError;
  final DateTime timestamp;

  const ArsenalErrorDetails({
    required this.category,
    required this.operation,
    required this.message,
    required this.originalError,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'ArsenalError: [$category] $operation - $message';
  }
}