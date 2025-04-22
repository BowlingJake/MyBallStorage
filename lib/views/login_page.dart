import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  bool _isLoggedIn = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final logged = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _isLoggedIn = logged;
      _loading = false;
    });
  }

  Future<void> _doLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _doLogin,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 背景占位
            Container(color: Colors.blueGrey[50]),

            // 中心內容
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo 占位
                const FlutterLogo(size: 100),
                const SizedBox(height: 40),

                if (!_isLoggedIn) ...[
                  // 未登入：顯示帳號／密碼輸入框
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                    child: TextField(
                      controller: _userCtrl,
                      decoration: const InputDecoration(labelText: '帳號'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                    child: TextField(
                      controller: _passCtrl,
                      decoration: const InputDecoration(labelText: '密碼'),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 提示文字：點任意處登入
                  const Text(
                    '點任意處登入',
                    style: TextStyle(fontSize: 16),
                  ),
                ] else ...[
                  // 已登入：提示點任意處開始
                  const Text(
                    '點任意處開始',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
