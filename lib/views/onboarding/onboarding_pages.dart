import 'package:flutter/material.dart';

class OnboardingPages {
  static Widget buildWelcomePage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_handball,
            size: 120,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 32),
          const Text(
            '歡迎使用 StrikeTrack！',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            '讓我們幫您設定個人檔案，\n打造專屬的保齡球管理體驗',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static Widget buildNicknamePage({
    required TextEditingController controller,
    required VoidCallback onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person, size: 80, color: Colors.blue),
          const SizedBox(height: 32),
          const Text(
            '設定您的暱稱',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('這將作為您在應用中的顯示名稱', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: '暱稱',
              hintText: '請輸入您的暱稱',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => onChanged(),
          ),
        ],
      ),
    );
  }

  static Widget buildHandPage({
    required List<String> options,
    required String selectedValue,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.back_hand, size: 80, color: Colors.orange),
          const SizedBox(height: 32),
          const Text(
            '選擇您的慣用手',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('這將幫助我們提供更精確的建議', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          Column(
            children:
                options.map((hand) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(hand),
                      leading: Radio<String>(
                        value: hand,
                        groupValue: selectedValue,
                        onChanged: (value) => onChanged(value!),
                      ),
                      onTap: () => onChanged(hand),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  static Widget buildBallPathPage({
    required List<String> options,
    required String selectedValue,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.track_changes, size: 80, color: Colors.green),
          const SizedBox(height: 32),
          const Text(
            '選擇您的慣用球路',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('幫助我們推薦適合的球類', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          Column(
            children:
                options.map((path) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(path),
                      leading: Radio<String>(
                        value: path,
                        groupValue: selectedValue,
                        onChanged: (value) => onChanged(value!),
                      ),
                      onTap: () => onChanged(path),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  static Widget buildPAPPage({
    required TextEditingController controller,
    required VoidCallback onChanged,
    required VoidCallback onSkip,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.gps_fixed, size: 80, color: Colors.red),
          const SizedBox(height: 32),
          const Text(
            '設定您的 PAP 值',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'PAP (Positive Axis Point) 是個人球路分析的重要參數\n如果不確定可以先跳過，之後再設定',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'PAP 值',
              hintText: '例如：4.5" x 0.5" up',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 16),
          TextButton(onPressed: onSkip, child: const Text('稍後設定')),
        ],
      ),
    );
  }
}
