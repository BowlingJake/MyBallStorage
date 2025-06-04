// lib/brand_colors.dart (假設你放在 lib 資料夾下)
import 'package:flutter/material.dart';

// 根據實際品牌顏色更新的漸層色配置
// 鍵：品牌名稱 (String)
// 值：List<Color> 代表漸層色 (至少兩種顏色)
Map<String, List<Color>> brandGradientColors = {
  // STORM - 青綠色
  'Storm': [const Color(0xFF00A693), const Color(0xFF00D4B8)],
  'Storm Bowling': [const Color(0xFF00A693), const Color(0xFF00D4B8)],
  
  // MOTIV - 橘色
  'Motiv': [const Color(0xFFFF6B35), const Color(0xFFFF8C42)],
  'Motiv Bowling': [const Color(0xFFFF6B35), const Color(0xFFFF8C42)],
  
  // Brunswick - 藍色
  'Brunswick': [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
  'Brunswick Bowling': [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
  
  // 900 GLOBAL - 黃色
  '900 Global': [const Color(0xFFFFB000), const Color(0xFFFFC933)],
  
  // HAMMER - 橘紅色
  'Hammer': [const Color(0xFFFF4500), const Color(0xFFFF6B35)],
  'Hammer Bowling': [const Color(0xFFFF4500), const Color(0xFFFF6B35)],
  
  // Roto Grip - 深紅/紫紅色
  'Roto Grip': [const Color(0xFFDC143C), const Color(0xFFFF1744)],
  
  // EBONITE - 深藍色
  'Ebonite': [const Color(0xFF1B2B5E), const Color(0xFF2563EB)],
  
  // DV8 - 黑色/深灰色
  'DV8 Bowling': [const Color(0xFF1F1F1F), const Color(0xFF4A4A4A)],
  'DV8': [const Color(0xFF1F1F1F), const Color(0xFF4A4A4A)],
  
  // 其他品牌根據實際 LOGO 顏色更新
  // Track - 深藍色配橘色
  'Track': [const Color(0xFF1E3A8A), const Color(0xFFFF6B35)],
  'Track Bowling': [const Color(0xFF1E3A8A), const Color(0xFFFF6B35)],
  
  // Columbia 300 - 紅色配深色
  'Columbia 300': [const Color(0xFFDC2626), const Color(0xFF991B1B)],
  
  // Radical - 黃色配黑色
  'Radical': [const Color(0xFFFDDD00), const Color(0xFF1F1F1F)],
  'Radical Bowling': [const Color(0xFFFDDD00), const Color(0xFF1F1F1F)],
  
  // SWAG - 螢光綠色系
  'SWAG': [const Color(0xFF84CC16), const Color(0xFFBEF264)],
  'SWAG Bowling': [const Color(0xFF84CC16), const Color(0xFFBEF264)],
  
  'Pyramid': [const Color(0xFFFFAA00), const Color(0xFFFFDD66)],
};

// 如果品牌未找到或沒有特定顏色，則使用預設漸層色
List<Color> getDefaultGradient(ThemeData theme) {
  return [
    theme.colorScheme.primaryContainer.withOpacity(0.7), // 使用 Container 顏色可能更適合背景
    theme.colorScheme.secondaryContainer.withOpacity(0.8),
  ];
}

// 根據品牌名稱獲取漸層顏色
List<Color> getGradientColorsForBrand(String brandName, ThemeData theme) {
  // 首先嘗試直接匹配
  if (brandGradientColors.containsKey(brandName)) {
    print('找到品牌顏色: $brandName');
    return brandGradientColors[brandName]!;
  }
  
  // 如果直接匹配失敗，嘗試不區分大小寫的匹配
  final String lowerBrandName = brandName.toLowerCase();
  for (final entry in brandGradientColors.entries) {
    if (entry.key.toLowerCase() == lowerBrandName) {
      print('找到品牌顏色(不區分大小寫): $brandName -> ${entry.key}');
      return entry.value;
    }
  }
  
  // 如果還是找不到，嘗試部分匹配（去掉 "Bowling" 後綴）
  final String simplifiedBrandName = brandName.replaceAll(' Bowling', '').trim();
  if (brandGradientColors.containsKey(simplifiedBrandName)) {
    print('找到品牌顏色(簡化名稱): $brandName -> $simplifiedBrandName');
    return brandGradientColors[simplifiedBrandName]!;
  }
  
  print('未找到品牌顏色，使用預設: $brandName');
  return getDefaultGradient(theme);
}
