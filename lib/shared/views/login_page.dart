import 'dart:ui';

import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/routing/app_router_config.dart';
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
  bool _showEmailForm = false;
  int _tapCount = 0;
  DateTime? _lastTapTime;
  static const int _requiredTaps = 7;
  static const Duration _tapInterval = Duration(seconds: 2);
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

  // Email 登入邏輯
  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    
    print('Attempting Email Sign-In with ${_emailController.text}...');
    try {
      await ref.read(authControllerProvider.notifier).signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      if (mounted) {
        // 登入成功後，路由會自動重導向，不需要手動導航
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('登入成功！')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('登入失敗：$e')),
        );
      }
    }
  }

  Future<void> _handleLoginAction(Future<void> Function() loginFuture) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 呼叫傳入的登入操作
      await loginFuture();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('登入失敗：$e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleDeveloperTap() {
    final now = DateTime.now();
    if (_lastTapTime != null && now.difference(_lastTapTime!) > _tapInterval) {
      _tapCount = 0;
    }
    _tapCount++;
    _lastTapTime = now;

    if (_tapCount >= _requiredTaps) {
      _tapCount = 0;
      _lastTapTime = null;
      // 使用 GoRouter 導航到主頁（開發者通道）
      ref.read(routerProvider).go('/');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('進入開發者通道')));
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
                      GestureDetector(
                        onTap: _handleDeveloperTap,
                        child: Text(
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
                          // Email Login Toggle Button
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _showEmailForm = !_showEmailForm;
                              });
                            },
                            child: Text(
                              _showEmailForm ? '使用其他方式登入' : '使用 Email 登入（測試用）',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          
                          // Email Login Form
                          if (_showEmailForm) ...[
                            const SizedBox(height: 16),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Email TextField
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    autocorrect: false,
                                    enableSuggestions: true,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                      hintText: 'test@bowlingarsenal.com',
                                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                      prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.white, width: 2),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.red),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.red, width: 2),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.1),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '請輸入Email';
                                      }
                                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                        return '請輸入有效的Email格式';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Password TextField
                                  TextFormField(
                                    controller: _passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    textInputAction: TextInputAction.done,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    obscureText: true,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: '密碼',
                                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                      hintText: 'TestPassword123!',
                                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.white, width: 2),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.red),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.red, width: 2),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.1),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '請輸入密碼';
                                      }
                                      if (value.length < 6) {
                                        return '密碼至少需要6個字符';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Email Login Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : () => _handleLoginAction(_signInWithEmail),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: theme.colorScheme.primary,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            )
                                          : const Text(
                                              '登入',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Divider
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    '或',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                          
                          // 只有在不顯示Email表單時才顯示其他登入按鈕
                          if (!_showEmailForm) ...[
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
                          ],
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
