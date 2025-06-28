// lib/models/user_profile.dart
class UserProfile {
  final String nickname;
  final String hand;
  final String ballPath;
  final String pap;

  const UserProfile({
    required this.nickname,
    required this.hand,
    required this.ballPath,
    required this.pap,
  });

  UserProfile copyWith({
    String? nickname,
    String? hand,
    String? ballPath,
    String? pap,
  }) {
    return UserProfile(
      nickname: nickname ?? this.nickname,
      hand: hand ?? this.hand,
      ballPath: ballPath ?? this.ballPath,
      pap: pap ?? this.pap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'hand': hand,
      'ballPath': ballPath,
      'pap': pap,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nickname: json['nickname'] ?? '',
      hand: json['hand'] ?? '',
      ballPath: json['ballPath'] ?? '',
      pap: json['pap'] ?? '',
    );
  }

  @override
  String toString() {
    return 'UserProfile(nickname: $nickname, hand: $hand, ballPath: $ballPath, pap: $pap)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.nickname == nickname &&
        other.hand == hand &&
        other.ballPath == ballPath &&
        other.pap == pap;
  }

  @override
  int get hashCode {
    return nickname.hashCode ^
        hand.hashCode ^
        ballPath.hashCode ^
        pap.hashCode;
  }
} 