class BowlingBall {
  final String ball;
  final String brand;
  final String releaseDate;
  final String coverstockname;
  final String coverstockcategory;
  final String factoryFinish;
  final String core;
  final String rg;
  final String diff;
  final String mbDiff;

  String? handType;
  String? layoutType;
  List<String>? layoutValues;

  BowlingBall({
    required this.ball,
    required this.brand,
    required this.releaseDate,
    required this.coverstockname,
    required this.coverstockcategory,
    required this.factoryFinish,
    required this.core,
    required this.rg,
    required this.diff,
    required this.mbDiff,
  });

  factory BowlingBall.fromJson(Map<String, dynamic> json) {
    return BowlingBall(
      ball: json['Ball'] ?? '',
      brand: json['Brand'] ?? '',
      releaseDate: json['Release Date'] ?? '',
      coverstockname: json['Coverstock Name'] ?? '',
      coverstockcategory: json['Coverstock Category'] ?? '',
      factoryFinish: json['Factory Finish'] ?? '',
      core: json['Core'] ?? '',
      rg: json['RG'] ?? '',
      diff: json['Diff'] ?? '',
      mbDiff: json['MB Diff'] ?? '',
    );
  }
}
