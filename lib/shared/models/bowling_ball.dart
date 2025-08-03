import 'package:freezed_annotation/freezed_annotation.dart';

part 'bowling_ball.freezed.dart';

@freezed
class BowlingBall with _$BowlingBall {
  const factory BowlingBall({
    // 來自 Supabase 的標準欄位 (已整合)
    required int id,
    @Default('Unknown Ball') String name,
    @Default('Unknown Brand') String brand,
    String? coreName,
    String? coreType,
    String? coverstockType,
    @Default('https://via.placeholder.com/150') String imageUrl,
    double? rg,
    double? diff,
    double? mbDiff, // 對應 Supabase 的 mb_diff
    String? region,
    String? slug,
    String? createdAt,

    // 為了兼容舊資料而保留的欄位
    String? coverstock,
    String? coverstockName,
    String? factoryFinish,
    String? releaseDate,

    // 用戶自定義數據 (完全保留)
    String? handType,
    String? layoutType,
    List<String>? layoutValues,
  }) = _BowlingBall;

  /// 客製化的 fromJson 工廠方法，能同時支持 Supabase 和舊有的 JSON 格式
  factory BowlingBall.fromJson(Map<String, dynamic> json) {
    
    // Helper to safely parse double values (你的這段邏輯很棒，完全保留)
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
      // --- Supabase 欄位對應 ---
      id: json['id'] as int? ?? 0,
      name: json['ball_name'] as String? ?? json['name'] as String? ?? json['Ball'] as String? ?? 'Unknown Ball',
      brand: json['brand'] as String? ?? json['Brand'] as String? ?? 'Unknown Brand',
      coreName: json['core_name'] as String?,
      coreType: json['core_type'] as String?,
      coverstockType: json['coverstock_type'] as String? ?? json['coverstock_tpye'] as String?,
      coverstockName: json['coverstock_name'] as String?,
      coverstock: json['coverstock'] as String?,
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String? ?? 'https://via.placeholder.com/150',
      rg: tryParseDouble(json['rg'] ?? json['RG']),
      diff: tryParseDouble(json['diff'] ?? json['Diff']),
      mbDiff: tryParseDouble(json['mb_diff'] ?? json['intDiff'] ?? json['MB Diff']),
      region: json['region'] as String?,
      slug: json['slug'] as String?,
      createdAt: json['created_at'] as String? ?? json['create_at'] as String?,


      // --- 舊資料兼容欄位 ---
      factoryFinish: json['factory_finish'] as String?,
      releaseDate: json['release_date'] as String?,
      
      // --- 用戶自定義數據 ---
      handType: json['handType'] as String?,
      layoutType: json['layoutType'] as String?,
      layoutValues: json['layoutValues'] != null ? List<String>.from(json['layoutValues'] as List) : null,
    );
  }
}

// 擴展方法，包含你的商業邏輯 (完全保留)
extension BowlingBallExtension on BowlingBall {
  /// 提供 core 屬性以兼容現有代碼
  String get core {
    if (coreName != null && coreName!.isNotEmpty) {
      if (coreType != null && coreType!.isNotEmpty) {
        return '$coreName $coreType';
      }
      return coreName!;
    }
    if (coreType != null && coreType!.isNotEmpty) {
      return coreType!;
    }
    return 'Unknown Core';
  }

  /// 提供 cover 屬性以兼容現有代碼
  String get cover {
    return combinedCoverstockInfo;
  }

  String get combinedCoverstockInfo {
    final name = coverstockName ?? '';
    final category = coverstockType ?? coverstock ?? ''; // 優先使用 coverstockType

    if (name.isEmpty && category.isEmpty) {
      return '未知';
    }
    if (name.isEmpty) {
      return category;
    }
    if (category.isEmpty) {
      return name;
    }

    // 檢查名稱是否已經包含類別信息
    final lowerName = name.toLowerCase();
    
    if (lowerName.contains('reactive') || lowerName.contains('urethane') || lowerName.contains('polyester')) {
      return name; // 名稱已經包含類別信息
    }
    
    // 智能組合名稱和類別
    return '$name $category';
  }

  /// 自定義toJson方法，確保包含用戶定義的字段 (完全保留)
  Map<String, dynamic> toJsonWithCustomFields() => {
        'id': id,
        'name': name,
        'brand': brand,
        'coreName': coreName,
        'coreType': coreType,
        'coverstockType': coverstockType,
        'coverstock': coverstock,
        'coverstockName': coverstockName,
        'factoryFinish': factoryFinish,
        'releaseDate': releaseDate,
        'imageUrl': imageUrl,
        'rg': rg,
        'diff': diff,
        'mbDiff': mbDiff,
        'region': region,
        'slug': slug,
        'createdAt': createdAt,
        'handType': handType,
        'layoutType': layoutType,
        'layoutValues': layoutValues,
      };
}