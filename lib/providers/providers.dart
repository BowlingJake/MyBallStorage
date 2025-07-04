// lib/providers/providers.dart
// 統一匯出所有 Provider，方便其他檔案使用

import 'package:bowlingarsenal_app/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/providers/auth_provider.dart';
import 'package:bowlingarsenal_app/providers/onboarding_provider.dart';
import 'package:bowlingarsenal_app/providers/user_profile_provider.dart';
import 'package:bowlingarsenal_app/services/ball_data_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'auth_provider.dart';
export 'onboarding_provider.dart';
export 'user_profile_provider.dart';

/// 提供保齡球列表的 FutureProvider
///
/// 會自動處理讀取、快取（由 BallDataService 處理）、錯誤和成功狀態
final ballListProvider = FutureProvider<List<BowlingBall>>((ref) {
  return BallDataService.loadBallData();
});

// 計算型 Provider - 檢查是否需要顯示 Onboarding
final shouldShowOnboardingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);

  if (authState.status != AuthStatus.authenticated) {
    return false;
  }

  // 當 auth 狀態確定後，監聽其他 providers
  final onboardingCompleted = ref.watch(onboardingProvider);
  final userProfile = ref.watch(userProfileProvider);

  // 如果 onboarding 未完成，總是要顯示
  if (!onboardingCompleted) {
    return true;
  }

  // 如果 onboarding 已完成，但 profile 不完整，也要顯示
  // (userProfile 為 null 也算不完整)
  final isProfileComplete =
      ref.read(userProfileProvider.notifier).isProfileComplete;
  if (!isProfileComplete) {
    return true;
  }

  // 所有條件都滿足，不顯示 onboarding
  return false;
});

// --- Ball Library Filter and Sort Providers ---

// +++ 型別安全的排序邏輯 +++
enum SortField { name, rg }

class SortCriterion {
  final SortField field;
  final bool ascending;

  const SortCriterion({required this.field, required this.ascending});

  // 覆寫 toString 以便在 UI 上顯示
  String get displayName {
    final fieldName = field.toString().split('.').last.toUpperCase();
    final direction = ascending ? '(Low-High)' : '(High-Low)';
    return '$fieldName $direction';
  }
}
// +++ End +++

// 1. 搜尋文字的狀態
final ballSearchTextProvider = StateProvider<String>((ref) => '');

// 2. 篩選條件的狀態
final ballFiltersProvider = StateProvider<Map<String, String?>>((ref) => {
      'brand': null,
      'core': null,
      'coverstock': null,
    });

// 3. 排序條件的狀態 (使用新的 SortCriterion class)
final ballSortProvider =
    StateProvider<SortCriterion>((ref) => const SortCriterion(field: SortField.name, ascending: true));

// --- Top-level helper functions for filtering (moved from the widget) ---

bool _matchesBrandFilter(String ballBrand, String? selectedBrand) {
  if (selectedBrand == null) return true;
  return ballBrand.toLowerCase().contains(selectedBrand.toLowerCase());
}

bool _matchesCoreFilter(String ballCore, String? selectedCore) {
  if (selectedCore == null) return true;
  final coreCategory = ballCore.trim().split(' ').last;
  return coreCategory.toLowerCase() == selectedCore.toLowerCase();
}

bool _matchesCoverstockFilter(String ballCoverstock, String? selectedCoverstock) {
  if (selectedCoverstock == null) return true;
  final coverLower = ballCoverstock.toLowerCase();
  final selectedLower = selectedCoverstock.toLowerCase();
  if (selectedLower == 'urethane') return coverLower.contains('urethane');
  if (selectedLower == 'polyester') return coverLower.contains('polyester') || coverLower.contains('poly');
  if (selectedLower == 'solid reactive') return coverLower.contains('solid') && coverLower.contains('reactive');
  if (selectedLower == 'pearl reactive') return coverLower.contains('pearl') && coverLower.contains('reactive');
  if (selectedLower == 'hybrid reactive') return coverLower.contains('hybrid') && coverLower.contains('reactive');
  return false;
}


// 4. 主要的計算 Provider，結合所有篩選和排序邏輯
final filteredBallListProvider = Provider<List<BowlingBall>>((ref) {
  // 依賴原始列表、搜尋、篩選和排序 providers
  final allBalls = ref.watch(ballListProvider).value ?? [];
  final searchText = ref.watch(ballSearchTextProvider);
  final selectedFilters = ref.watch(ballFiltersProvider);
  final sortCriteria = ref.watch(ballSortProvider);

  var items = List<BowlingBall>.from(allBalls);

  // 搜尋邏輯
  if (searchText.isNotEmpty) {
    items = items
        .where((ball) =>
            ball.name.toLowerCase().contains(searchText.toLowerCase()) ||
            ball.brand.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }

  // 篩選邏輯
  if (selectedFilters['brand'] != null) {
    items = items.where((ball) => _matchesBrandFilter(ball.brand, selectedFilters['brand'])).toList();
  }
  if (selectedFilters['core'] != null) {
    items = items.where((ball) => _matchesCoreFilter(ball.core, selectedFilters['core'])).toList();
  }
  if (selectedFilters['coverstock'] != null) {
    items = items.where((ball) => _matchesCoverstockFilter(ball.coverstock, selectedFilters['coverstock'])).toList();
  }

  // 排序邏輯
  items.sort((a, b) {
    int comparison;
    switch (sortCriteria.field) {
      case SortField.name:
        comparison = a.name.compareTo(b.name);
        break;
      case SortField.rg:
        if (a.rg == null && b.rg == null) {
          comparison = a.name.compareTo(b.name);
        } else if (a.rg == null) {
          comparison = 1;
        } else if (b.rg == null) {
          comparison = -1;
        } else {
          comparison = a.rg!.compareTo(b.rg!);
          if (comparison == 0) {
            comparison = a.name.compareTo(b.name);
          }
        }
        break;
    }
    return sortCriteria.ascending ? comparison : -comparison;
  });

  return items;
});
