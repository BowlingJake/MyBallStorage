import 'package:flutter/material.dart';

class BallListHeader extends StatelessWidget {
  const BallListHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 移除多餘的標題橫條，返回空容器
    return const SizedBox.shrink();
  }
} 