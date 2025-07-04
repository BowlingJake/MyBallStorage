import 'dart:ui';

import 'package:bowlingarsenal_app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isLoading = false;

  // Placeholder for Google Sign-In logic
  Future<void> _signInWithGoogle() async {
    // This would call your auth provider's Google sign-in method
    // For now, it's a placeholder.
    print('Attempting Google Sign-In...');
    // You would typically set loading state and handle success/error
  }

  // Placeholder for Apple Sign-In logic
  Future<void> _signInWithApple() async {
    print('Attempting Apple Sign-In...');
  }

  // Placeholder for Phone Sign-In logic
  Future<void> _signInWithPhone() async {
    print('Attempting Phone Sign-In...');
  }

  Future<void> _doGuestLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 以訪客身份登入
      await ref.read(authProvider.notifier).loginAsGuest();

      // 登入成功後，AppRouter 會自動導航到主頁（跳過 Onboarding）
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('訪客登入失敗：$e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Sport_Tech_Background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Loading Indicator
          if (_isLoading)
            ColoredBox(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),

          // Login UI
          SafeArea(
            child: Column(
              children: [
                // Top section with Logo and Title
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo_placeholder.png',
                        height: 120,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'StrikeTrack',
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          shadows: [
                            const Shadow(
                              color: Colors.black54,
                              blurRadius: 15,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '您的專業保齡球數據庫',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(0.85),
                          letterSpacing: 1.2,
                          shadows: [
                            const Shadow(
                              color: Colors.black38,
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Frosted Glass Container
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Custom Google Sign-in Button
                          SignInButtonBuilder(
                            text: '使用 Google 帳戶登入',
                            icon: Icons.circle_outlined,
                            onPressed: _isLoading ? () {} : _signInWithGoogle,
                            backgroundColor: Colors.white,
                            textColor: Colors.black.withOpacity(0.8),
                            iconColor: Colors.black.withOpacity(0.8),
                            fontSize: 16,
                            height: 50,
                            width: double.infinity,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Custom Apple Sign-in Button
                          SignInButtonBuilder(
                            text: '使用 Apple 帳戶登入',
                            icon: Icons.apple,
                            onPressed: _isLoading ? () {} : _signInWithApple,
                            backgroundColor: Colors.black,
                            fontSize: 16,
                            height: 50,
                            width: double.infinity,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Custom Phone Sign-in Button
                          SignInButtonBuilder(
                            text: '使用手機號碼登入',
                            icon: Icons.phone_iphone,
                            onPressed: _isLoading ? () {} : _signInWithPhone,
                            backgroundColor: theme.colorScheme.primary
                                .withOpacity(0.9),
                            fontSize: 16,
                            height: 50,
                            width: double.infinity,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: _isLoading ? null : _doGuestLogin,
                            child: Text(
                              '以訪客身份繼續',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
