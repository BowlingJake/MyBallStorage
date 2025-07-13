import 'package:flutter/foundation.dart';

@immutable
class RollRecord {
  final List<bool> pinsDown;

  const RollRecord({required this.pinsDown});

  int get pinsDownCount => pinsDown.where((p) => p).length;

  RollRecord copyWith({
    List<bool>? pinsDown,
  }) {
    return RollRecord(
      pinsDown: pinsDown ?? this.pinsDown,
    );
  }

  @override
  String toString() => 'RollRecord(pinsDown: $pinsDown)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is RollRecord &&
      listEquals(other.pinsDown, pinsDown);
  }

  @override
  int get hashCode => pinsDown.hashCode;
} 