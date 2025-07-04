class BowlingBall {
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
    double? _tryParseDouble(dynamic value) {
      if (value is num) {
        return value.toDouble();
      }
      if (value is String) {
        return double.tryParse(value);
      }
      return null;
    }

    return BowlingBall(
      id: json['id'] as String? ?? json['Ball'] as String? ?? '', // Support both id and Ball
      name: json['name'] as String? ?? json['Ball'] as String? ?? 'Unknown Ball',
      brand: json['brand'] as String? ?? json['Brand'] as String? ?? 'Unknown Brand',
      core: json['core'] as String? ?? json['Core'] as String? ?? '',
      coverstock: json['coverstock'] as String? ?? json['Coverstock Category'] as String? ?? '',
      coverstockName: json['coverstockName'] as String? ?? json['Coverstock Name'] as String? ?? '',
      factoryFinish: json['factoryFinish'] as String? ?? json['Factory Finish'] as String? ?? '',
      releaseDate: json['releaseDate'] as String? ?? json['Release Date'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? 'https://via.placeholder.com/150', // Provide a default
      rg: _tryParseDouble(json['rg'] ?? json['RG']),
      diff: _tryParseDouble(json['diff'] ?? json['Diff']),
      intDiff: _tryParseDouble(json['intDiff'] ?? json['MB Diff']),
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
    };
  }
}
