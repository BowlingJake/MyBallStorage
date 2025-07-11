import 'package:flutter_test/flutter_test.dart';
import 'package:bowlingarsenal_app/routing/auth_guard.dart';

void main() {
  group('AuthGuard', () {
    group('when user is not authenticated', () {
      const authState = AuthGuardState(
        isAuthenticated: false,
        shouldShowOnboarding: false,
      );

      test('redirects to login from any page except login', () {
        expect(authGuard(authState, '/'), equals('/login'));
        expect(authGuard(authState, '/onboarding'), equals('/login'));
        expect(authGuard(authState, '/library'), equals('/login'));
        expect(authGuard(authState, '/training'), equals('/login'));
        expect(authGuard(authState, '/my-arsenal'), equals('/login'));
        expect(authGuard(authState, '/settings'), equals('/login'));
      });

      test('does not redirect when already on login page', () {
        expect(authGuard(authState, '/login'), isNull);
      });
    });

    group('when user is authenticated but should show onboarding', () {
      const authState = AuthGuardState(
        isAuthenticated: true,
        shouldShowOnboarding: true,
      );

      test('redirects to onboarding from any page except onboarding', () {
        expect(authGuard(authState, '/'), equals('/onboarding'));
        expect(authGuard(authState, '/login'), equals('/onboarding'));
        expect(authGuard(authState, '/library'), equals('/onboarding'));
        expect(authGuard(authState, '/training'), equals('/onboarding'));
        expect(authGuard(authState, '/my-arsenal'), equals('/onboarding'));
        expect(authGuard(authState, '/settings'), equals('/onboarding'));
      });

      test('does not redirect when already on onboarding page', () {
        expect(authGuard(authState, '/onboarding'), isNull);
      });
    });

    group('when user is authenticated and has completed onboarding', () {
      const authState = AuthGuardState(
        isAuthenticated: true,
        shouldShowOnboarding: false,
      );

      test('redirects to home from login or onboarding pages', () {
        expect(authGuard(authState, '/login'), equals('/'));
        expect(authGuard(authState, '/onboarding'), equals('/'));
      });

      test('does not redirect from any other page', () {
        expect(authGuard(authState, '/'), isNull);
        expect(authGuard(authState, '/library'), isNull);
        expect(authGuard(authState, '/training'), isNull);
        expect(authGuard(authState, '/my-arsenal'), isNull);
        expect(authGuard(authState, '/settings'), isNull);
        expect(authGuard(authState, '/developer'), isNull);
      });
    });

    group('AuthGuardState', () {
      test('can be created with required parameters', () {
        const authState = AuthGuardState(
          isAuthenticated: true,
          shouldShowOnboarding: false,
        );

        expect(authState.isAuthenticated, isTrue);
        expect(authState.shouldShowOnboarding, isFalse);
      });
    });
  });
} 