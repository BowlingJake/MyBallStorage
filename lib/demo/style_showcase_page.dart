import 'package:bowlingarsenal_app/demo/cyberpunk_tech_style.dart';
import 'package:bowlingarsenal_app/demo/dark_tech_style.dart';
import 'package:bowlingarsenal_app/demo/digital_dashboard_style.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class StyleShowcasePage extends StatelessWidget {
  const StyleShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('APP 風格展示'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '選擇您的 APP 設計風格',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '三種精選專業風格，專為運動數據APP設計，融合現代科技感與數據可視化',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),
            
            Expanded(
              child: ListView(
                children: [

                  
                  _buildStyleCard(
                    context,
                    title: 'Cyberpunk Tech',
                    subtitle: '科技未來風格',
                    description: '賽博朋克科技感 + 霓虹發光效果\n終端機風格 + 掃描線動畫\n適合科技愛好者和未來主義用戶',
                    icon: Iconsax.cpu,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00FFFF), Color(0xFF8B5CF6)],
                    ),
                    features: ['🌆 賽博朋克', '💫 霓虹發光', '⚡ 掃描動畫', '🔮 科幻感'],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CyberpunkTechStyle()),
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  _buildStyleCard(
                    context,
                    title: 'Digital Dashboard',
                    subtitle: '數字儀表板風格',
                    description: '專業數據可視化 + 豐富圖表展示\n等寬字體數字 + KPI指標卡片\n適合數據分析和專業用途',
                    icon: Iconsax.chart,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                    ),
                    features: ['📊 數據圖表', '📈 KPI指標', '🔢 等寬字體', '📋 專業表格'],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DigitalDashboardStyle()),
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  

                  
                  _buildStyleCard(
                    context,
                    title: 'Professional Dark',
                    subtitle: '專業深色風格',
                    description: '專業運動數據分析界面 + 清晰數據可視化\n深色護眼設計 + 專業圖表展示\n適合專業球員和數據分析需求',
                    icon: Iconsax.chart_2,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF121212), Color(0xFF1E88E5)],
                    ),
                    features: ['📊 運動數據', '🎯 專業分析', '👁️ 護眼深色', '📈 成績追蹤'],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DarkTechStyle()),
                    ),
                  ),
                ],
              ),
            ),
            
            // 底部提示
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.info_circle,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '選擇風格後，我們可以將整個 APP 統一為該風格設計',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Gradient gradient,
    required List<String> features,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: gradient.colors.first.withOpacity(0.05) != Colors.transparent
            ? LinearGradient(
                colors: gradient.colors.map((c) => c.withOpacity(0.05)).toList(),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
          border: Border.all(
            color: gradient.colors.first.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 標題區域
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: gradient.colors.first.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: gradient.colors.first,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: gradient.colors.first.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: gradient.colors.first,
                      size: 16,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // 描述
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 特色功能
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: features.map((feature) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: gradient.colors.first.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: gradient.colors.first.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    feature,
                    style: TextStyle(
                      color: gradient.colors.first,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 