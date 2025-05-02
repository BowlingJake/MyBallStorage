import 'package:flutter/material.dart';
import '../services/user_preferences_service.dart';
import 'edit_user_page.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _svc = UserPreferencesService();
  String _nickname = '', _hand = '', _ballPath = '', _pap = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await _svc.loadProfile();
    setState(() {
      _nickname = data['nickname'] ?? '';
      _hand     = data['hand']     ?? '';
      _ballPath = data['ballPath'] ?? '';
      _pap      = data['pap']      ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('個人檔案'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditUserPage()),
              ).then((_) => _loadProfile());
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(title: const Text('暱稱'), subtitle: Text(_nickname)),
          const Divider(),
          ListTile(title: const Text('慣用手'), subtitle: Text(_hand)),
          const Divider(),
          ListTile(title: const Text('慣用球路'), subtitle: Text(_ballPath)),
          const Divider(),
          ListTile(title: const Text('PAP'), subtitle: Text(_pap)),
        ],
      ),
    );
  }
}
