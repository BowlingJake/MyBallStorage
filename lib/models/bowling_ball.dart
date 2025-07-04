class BowlingBall {
  BowlingBall({
    required this.id,
    required this.name,
    required this.brand,
    required this.core,
    required this.coverstock,
    required this.coverstockName,
    required this.factoryFinish,
    required this.releaseDate,
    required this.imageUrl,
    this.rg,
    this.diff,
    this.intDiff,
    this.handType,
    this.layoutType,
    this.layoutValues,
  });

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
      id:
          json['id'] as String? ??
          json['Ball'] as String? ??
          '', // Support both id and Ball
      name:
          json['name'] as String? ?? json['Ball'] as String? ?? 'Unknown Ball',
      brand:
          json['brand'] as String? ??
          json['Brand'] as String? ??
          'Unknown Brand',
      core: json['core'] as String? ?? json['Core'] as String? ?? '',
      coverstock:
          json['coverstock'] as String? ??
          json['Coverstock Category'] as String? ??
          '',
      coverstockName:
          json['coverstockName'] as String? ??
          json['Coverstock Name'] as String? ??
          '',
      factoryFinish:
          json['factoryFinish'] as String? ??
          json['Factory Finish'] as String? ??
          '',
      releaseDate:
          json['releaseDate'] as String? ??
          json['Release Date'] as String? ??
          '',
      imageUrl:
          json['image_url'] as String? ??
          'https://via.placeholder.com/150', // Provide a default
      rg: tryParseDouble(json['rg'] ?? json['RG']),
      diff: tryParseDouble(json['diff'] ?? json['Diff']),
      intDiff: tryParseDouble(json['intDiff'] ?? json['MB Diff']),
    );
  }
  final String id;
  final String name;
  final String brand;
  final String core;
  final String coverstock;
  final String coverstockName;
  final String factoryFinish;
  final String releaseDate;
  final String imageUrl;
  final double? rg;
  final double? diff;
  final double? intDiff;

  // 用戶自定義數據
  String? handType;
  String? layoutType;
  List<String>? layoutValues;

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

  Map<String, dynamic> toJson() {
    return {
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
    };
  }
}
