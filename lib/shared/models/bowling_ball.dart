import 'package:freezed_annotation/freezed_annotation.dart';

part 'bowling_ball.freezed.dart';

@freezed
class BowlingBall with _$BowlingBall {
  const factory BowlingBall({
    required String id,
    required String name,
    required String brand,
    required String core,
    required String coverstock,
    required String coverstockName,
    required String factoryFinish,
    required String releaseDate,
    @Default('https://via.placeholder.com/150') String imageUrl,
    double? rg,
    double? diff,
    double? intDiff,
    // 用戶自定義數據
    String? handType,
    String? layoutType,
    List<String>? layoutValues,
  }) = _BowlingBall;

  // 自定義fromJson工廠方法，支持多種JSON格式
  factory BowlingBall.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse double values
    double? tryParseDouble(dynamic value) {
      if (value is num) {
        return value.toDouble();
      }
      if (value is String) {
        return double.tryParse(value);
      }
      return null;
    }

    return BowlingBall(
      id: json['id'] as String? ?? json['Ball'] as String? ?? 'unknown',
      name: json['name'] as String? ?? json['Ball'] as String? ?? 'Unknown Ball',
      brand: json['brand'] as String? ?? json['Brand'] as String? ?? 'Unknown Brand',
      core: json['core'] as String? ?? json['Core'] as String? ?? '',
      coverstock: json['coverstock'] as String? ?? json['Coverstock Category'] as String? ?? '',
      coverstockName: json['coverstockName'] as String? ?? json['Coverstock Name'] as String? ?? '',
      factoryFinish: json['factoryFinish'] as String? ?? json['Factory Finish'] as String? ?? '',
      releaseDate: json['releaseDate'] as String? ?? json['Release Date'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? 'https://via.placeholder.com/150',
      rg: tryParseDouble(json['rg'] ?? json['RG']),
      diff: tryParseDouble(json['diff'] ?? json['Diff']),
      intDiff: tryParseDouble(json['intDiff'] ?? json['MB Diff']),
      handType: json['handType'] as String?,
      layoutType: json['layoutType'] as String?,
      layoutValues: json['layoutValues'] != null
          ? List<String>.from(json['layoutValues'] as List)
          : null,
    );
  }
}

// 擴展方法，包含業務邏輯
extension BowlingBallExtension on BowlingBall {
  String get combinedCoverstockInfo {
    if (coverstockName.isEmpty && coverstock.isEmpty) {
      return '未知';
    }

    final name = coverstockName;
    final category = coverstock;

    if (name.isEmpty) {
      return category.isNotEmpty ? category : '未知';
    }

    if (category.isEmpty) {
      return name;
    }

    // 檢查名稱是否已經包含類別信息
    final lowerName = name.toLowerCase();
    final lowerCategory = category.toLowerCase();

    if (lowerName.contains('reactive') ||
        lowerName.contains('urethane') ||
        lowerName.contains('polyester')) {
      return name; // 名稱已經包含類別信息
    }

    // 智能組合名稱和類別，避免重複
    if (lowerCategory.contains('pearl') && lowerName.contains('pearl')) {
      // 例如 "Reactor Pearl" + "Pearl Reactive" → "Reactor Pearl Reactive"
      return '$name Reactive';
    } else if (lowerCategory.contains('solid') && lowerName.contains('solid')) {
      // 例如 "HK22 Solid" + "Solid Reactive" → "HK22 Solid Reactive"
      return '$name Reactive';
    } else if (lowerCategory.contains('hybrid') && lowerName.contains('hybrid')) {
      // 例如 "R2S Hybrid" + "Hybrid Reactive" → "R2S Hybrid Reactive"
      return '$name Reactive';
    } else {
      // 一般情況，直接組合
      return '$name $category';
    }
  }

  /// 自定義toJson方法，確保包含用戶定義的字段
  Map<String, dynamic> toJsonWithCustomFields() => {
    'id': id,
    'name': name,
    'brand': brand,
    'core': core,
    'coverstock': coverstock,
    'coverstockName': coverstockName,
    'factoryFinish': factoryFinish,
    'releaseDate': releaseDate,
    'image_url': imageUrl,
    'rg': rg,
    'diff': diff,
    'intDiff': intDiff,
    'handType': handType,
    'layoutType': layoutType,
    'layoutValues': layoutValues,
  };
}
