import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color appBarColor = const Color(0xFF005BEA);
    final Color mainBgColor = const Color(0xFFA3D5DC);
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: SizedBox(
          height: 72, // LOGO放大
          child: Image.asset('assets/images/logo_placeholder.png', fit: BoxFit.contain),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: mainBgColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.account_circle, size: 60, color: appBarColor),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text('鄭行越', style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _NavIcon(icon: Icons.home, label: '首頁', selected: true),
                _NavIcon(icon: Icons.location_on, label: '打卡'),
                _NavIcon(icon: Icons.assignment, label: '表單'),
                _NavIcon(icon: Icons.calendar_today, label: '班表'),
                _NavIcon(icon: Icons.campaign, label: '公告'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  const _NavIcon({required this.icon, required this.label, this.selected = false});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: selected ? Color(0xFF005BEA) : Colors.grey, size: 28),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 13, color: Colors.black87)),
      ],
    );
  }
} 