class BowlingBall {
  const BowlingBall({
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
      handType: json['handType'] as String?,
      layoutType: json['layoutType'] as String?,
      layoutValues: json['layoutValues'] != null
          ? List<String>.from(json['layoutValues'] as List)
          : null,
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
  final String? handType;
  final String? layoutType;
  final List<String>? layoutValues;

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

  BowlingBall copyWith({
    String? id,
    String? name,
    String? brand,
    String? core,
    String? coverstock,
    String? coverstockName,
    String? factoryFinish,
    String? releaseDate,
    String? imageUrl,
    double? rg,
    double? diff,
    double? intDiff,
    String? handType,
    String? layoutType,
    List<String>? layoutValues,
  }) {
    return BowlingBall(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      core: core ?? this.core,
      coverstock: coverstock ?? this.coverstock,
      coverstockName: coverstockName ?? this.coverstockName,
      factoryFinish: factoryFinish ?? this.factoryFinish,
      releaseDate: releaseDate ?? this.releaseDate,
      imageUrl: imageUrl ?? this.imageUrl,
      rg: rg ?? this.rg,
      diff: diff ?? this.diff,
      intDiff: intDiff ?? this.intDiff,
      handType: handType ?? this.handType,
      layoutType: layoutType ?? this.layoutType,
      layoutValues: layoutValues ?? this.layoutValues,
    );
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
      'handType': handType,
      'layoutType': layoutType,
      'layoutValues': layoutValues,
    };
  }
}
