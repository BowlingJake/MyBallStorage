import 'package:flutter/material.dart';
import '../services/user_preferences_service.dart';
import '../theme/text_styles.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({Key? key}) : super(key: key);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _svc = UserPreferencesService();

  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _papBaseController = TextEditingController();
  final TextEditingController _papOffsetController = TextEditingController();
  String _papOffsetType = '無';

  String? _preferredHand;
  String? _preferredBallPath;

  final List<String> _handOptions = [
    '右手單手',
    '左手單手',
    '右手雙手',
    '左手雙手',
  ];

  final List<String> _ballPathOptions = [
    '曲球',
    '飛碟球',
  ];

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final data = await _svc.loadProfile();
    setState(() {
      _nicknameController.text = data['nickname'] ?? '';
      _preferredHand = data['hand'];
      _preferredBallPath = data['ballPath'];
      final pap = data['pap'] ?? '';
      if (pap.contains('上')) {
        _papOffsetType = '上';
        final parts = pap.split('上');
        _papBaseController.text = parts[0];
        _papOffsetController.text = parts.length > 1 ? parts[1] : '';
      } else if (pap.contains('下')) {
        _papOffsetType = '下';
        final parts = pap.split('下');
        _papBaseController.text = parts[0];
        _papOffsetController.text = parts.length > 1 ? parts[1] : '';
      } else {
        _papOffsetType = '無';
        _papBaseController.text = pap;
      }
    });
  }

  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    String combinedPap = _papBaseController.text;
    if (_papOffsetType != '無') {
      combinedPap += '$_papOffsetType${_papOffsetController.text}';
    }
    await _svc.saveProfile(
      nickname: _nicknameController.text,
      hand: _preferredHand!,
      ballPath: _preferredBallPath!,
      pap: combinedPap,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('使用者資訊已儲存', style: AppTextStyles.body)),
    );
    // 儲存完成後返回顯示頁面
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _papBaseController.dispose();
    _papOffsetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('編輯使用者資訊', style: AppTextStyles.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: '暱稱',
                  labelStyle: AppTextStyles.body,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '請輸入暱稱';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _preferredHand,
                decoration: const InputDecoration(
                  labelText: '慣用手',
                  labelStyle: AppTextStyles.body,
                ),
                items: _handOptions
                    .map((hand) => DropdownMenuItem(
                          value: hand,
                          child: Text(hand, style: AppTextStyles.body),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _preferredHand = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '請選擇慣用手';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _preferredBallPath,
                decoration: const InputDecoration(
                  labelText: '慣用球路',
                  labelStyle: AppTextStyles.body,
                ),
                items: _ballPathOptions
                    .map((path) => DropdownMenuItem(
                          value: path,
                          child: Text(path, style: AppTextStyles.body),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _preferredBallPath = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '請選擇慣用球路';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _papBaseController,
                      decoration: const InputDecoration(
                        labelText: '基本 PAP',
                        labelStyle: AppTextStyles.body,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '請輸入基本 PAP';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _papOffsetType,
                      decoration: const InputDecoration(
                        labelText: '偏移',
                        labelStyle: AppTextStyles.body,
                      ),
                      items: const [
                        DropdownMenuItem(value: '無', child: Text('無', style: AppTextStyles.body)),
                        DropdownMenuItem(value: '上', child: Text('上', style: AppTextStyles.body)),
                        DropdownMenuItem(value: '下', child: Text('下', style: AppTextStyles.body)),
                      ],
                      onChanged: (value) => setState(() {
                        _papOffsetType = value!;
                        if (_papOffsetType == '無') {
                          _papOffsetController.clear();
                        }
                      }),
                    ),
                  ),
                  if (_papOffsetType != '無') ...[
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _papOffsetController,
                        decoration: InputDecoration(
                          labelText: _papOffsetType == '上' ? '上偏移量' : '下偏移量',
                          labelStyle: AppTextStyles.body,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '請輸入偏移量';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('儲存', style: AppTextStyles.button),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
