class OilPattern {
  final String name;
  final String lengthInFeet;

  OilPattern({
    required this.name,
    this.lengthInFeet = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lengthInFeet': lengthInFeet,
    };
  }

  factory OilPattern.fromJson(Map<String, dynamic> json) {
    return OilPattern(
      name: json['name'] ?? '',
      lengthInFeet: json['lengthInFeet'] ?? '',
    );
  }

  OilPattern copyWith({
    String? name,
    String? lengthInFeet,
  }) {
    return OilPattern(
      name: name ?? this.name,
      lengthInFeet: lengthInFeet ?? this.lengthInFeet,
    );
  }
}

class UserProfile {
  final String nickname;
  final String hand;
  final String ballPath;
  final String pap;
  final String country;
  final String city;
  final String bowlingStyle;
  final List<String> favoriteCenters;
  final List<OilPattern> favoriteOilPatterns;

  UserProfile({
    required this.nickname,
    required this.hand,
    required this.ballPath,
    required this.pap,
    this.country = '',
    this.city = '',
    this.bowlingStyle = '',
    this.favoriteCenters = const [],
    this.favoriteOilPatterns = const [],
  });

  String get location {
    if (country.isEmpty && city.isEmpty) return '';
    if (country.isEmpty) return city;
    if (city.isEmpty) return country;
    return '$city, $country';
  }

  UserProfile copyWith({
    String? nickname,
    String? hand,
    String? ballPath,
    String? pap,
    String? country,
    String? city,
    String? bowlingStyle,
    List<String>? favoriteCenters,
    List<OilPattern>? favoriteOilPatterns,
  }) {
    return UserProfile(
      nickname: nickname ?? this.nickname,
      hand: hand ?? this.hand,
      ballPath: ballPath ?? this.ballPath,
      pap: pap ?? this.pap,
      country: country ?? this.country,
      city: city ?? this.city,
      bowlingStyle: bowlingStyle ?? this.bowlingStyle,
      favoriteCenters: favoriteCenters ?? this.favoriteCenters,
      favoriteOilPatterns: favoriteOilPatterns ?? this.favoriteOilPatterns,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'hand': hand,
      'ballPath': ballPath,
      'pap': pap,
      'country': country,
      'city': city,
      'bowlingStyle': bowlingStyle,
      'favoriteCenters': favoriteCenters,
      'favoriteOilPatterns': favoriteOilPatterns.map((pattern) => pattern.toJson()).toList(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nickname: json['nickname'] ?? '',
      hand: json['hand'] ?? '',
      ballPath: json['ballPath'] ?? '',
      pap: json['pap'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      bowlingStyle: json['bowlingStyle'] ?? '',
      favoriteCenters: List<String>.from(json['favoriteCenters'] ?? []),
      favoriteOilPatterns: (json['favoriteOilPatterns'] as List<dynamic>? ?? [])
          .map((patternJson) => OilPattern.fromJson(patternJson))
          .toList(),
    );
  }
} 