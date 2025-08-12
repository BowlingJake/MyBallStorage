import 'package:flutter/material.dart';

/// 袋子顏色管理服務
/// 統一管理所有球袋的顏色定義，避免重複程式碼
class BagColorService {
  BagColorService._(); // 私有建構子，確保只能使用靜態方法

  /// 標準的袋子顏色陣列
  /// 按照袋子編號順序排列，與使用者配置檔案的袋子編號對應
  static const List<Color> standardBagColors = [
    Colors.orange,  // 袋子1 - 🟠 主球袋/日常練習
    Colors.red,     // 袋子2 - 🔴 進攻/重型球
    Colors.yellow,  // 袋子3 - 🟡 全能/中型球
    Colors.green,   // 袋子4 - 🟢 備用/新手球
    Colors.blue,    // 袋子5 - 🔵 進階/技術球
    Colors.purple,  // 袋子6 - 🟣 實驗/測試球
    Colors.cyan,    // 袋子7 - 🔵 青色/專業球
    Colors.pink,    // 袋子8 - 🩷 粉色/特殊球
    Colors.indigo,  // 袋子9 - 🟦 靛色/高級球
  ];

  /// 根據袋子編號獲取對應顏色
  /// [bagNumber] 袋子編號（從1開始）
  /// 返回對應的顏色，如果編號超出範圍則返回預設灰色
  static Color getBagColor(int bagNumber) {
    if (bagNumber < 1 || bagNumber > standardBagColors.length) {
      return Colors.grey; // 超出範圍時的預設顏色
    }
    return standardBagColors[bagNumber - 1]; // 袋子編號從1開始，陣列索引從0開始
  }

  /// 獲取所有袋子顏色的副本
  /// 返回不可變的顏色列表
  static List<Color> getAllBagColors() {
    return List.unmodifiable(standardBagColors);
  }

  /// 根據袋子編號列表獲取對應的顏色列表
  /// [bagNumbers] 袋子編號列表
  /// 返回對應顏色的列表
  static List<Color> getBagColors(List<int> bagNumbers) {
    return bagNumbers.map((number) => getBagColor(number)).toList();
  }

  /// 獲取袋子顏色的十六進制字符串表示
  /// [bagNumber] 袋子編號
  /// 返回顏色的十六進制字符串，例如 "#FF5722"
  static String getBagColorHex(int bagNumber) {
    final color = getBagColor(bagNumber);
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  /// 檢查指定袋子編號是否有效
  /// [bagNumber] 袋子編號
  /// 返回是否為有效的袋子編號
  static bool isValidBagNumber(int bagNumber) {
    return bagNumber >= 1 && bagNumber <= standardBagColors.length;
  }

  /// 獲取支援的最大袋子數量
  static int get maxBagCount => standardBagColors.length;

  /// 獲取袋子顏色的淡化版本（帶透明度）
  /// [bagNumber] 袋子編號
  /// [opacity] 透明度（0.0 - 1.0）
  /// 返回帶透明度的顏色
  static Color getBagColorWithOpacity(int bagNumber, double opacity) {
    return getBagColor(bagNumber).withOpacity(opacity);
  }

  /// 為特定袋子獲取漸層顏色
  /// [bagNumber] 袋子編號
  /// 返回基於袋子顏色的漸層
  static LinearGradient getBagGradient(int bagNumber) {
    final baseColor = getBagColor(bagNumber);
    return LinearGradient(
      colors: [
        baseColor.withOpacity(0.8),
        baseColor,
        baseColor.withOpacity(0.6),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}