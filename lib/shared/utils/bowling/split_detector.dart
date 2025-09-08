import 'package:flutter/foundation.dart';

/// 判斷第一球是否為分瓶（Split）的工具類
class SplitDetector {
  /// 判斷是否為分瓶
  /// [firstRollDown] 長度10，true 代表第一球擊倒該瓶
  /// 預設不將 washout 納入（即要求 1 號瓶已倒）
  static bool isSplit(List<bool> firstRollDown, {bool includeWashout = false}) {
    if (firstRollDown.length != 10) return false;

    // 剩餘站立的瓶（false 代表站立）
    final List<int> standing = <int>[
      for (int i = 0; i < 10; i++) if (!firstRollDown[i]) i + 1,
    ];

    // 不是 Strike，且至少兩瓶站立
    if (standing.length < 2 || standing.length > 7) return false;

    // 非 washout：要求 1 號瓶已倒
    final bool headpinDown = firstRollDown[0];
    if (!includeWashout && !headpinDown) return false;

    // 規則化判斷：
    // A) 同排出現「間隔」：像 4-6、7-10（中間至少空一個）
    if (_hasRowGap(standing.toSet())) return true;

    // B) 同排相鄰組，且其正前方的瓶已倒：如 4-5 且 2 倒，或 5-6 且 3 倒，7-8 且 4 倒 ...
    if (_hasFrontClearedAdjacentPair(standing.toSet(), firstRollDown)) return true;

    // 與常見 Split 模式比對（補充覆蓋）
    final Set<int> set = standing.toSet();
    for (final pattern in _splitPatterns) {
      if (set.length == pattern.length && set.containsAll(pattern)) {
        return true;
      }
    }

    return false;
  }

  /// 常見分瓶模式（站立瓶集合）
  static final List<Set<int>> _splitPatterns = <Set<int>>[
    // 極端
    {7, 10},
    // 中路左右分離
    {4, 6},
    {4, 6, 7},
    {4, 6, 10},
    {4, 6, 7, 10},
    // 邊角搭配
    {2, 7},
    {3, 10},
    {7, 9},
    {8, 10},
    // 五號搭配
    {5, 7},
    {5, 10},
    {5, 7, 10},
    {5, 6, 10},
    {4, 5, 7},
    {4, 5, 7, 10},
    // 四角殘留延伸（涵蓋更多少見情形）
    {2, 4, 5, 7},
    {3, 5, 6, 10},
  ];
}

// 1~10 號瓶的鄰接關係（依幾何相鄰）
bool _areAdjacent(int a, int b) {
  // 同一排左右相鄰
  const row1 = [1];
  const row2 = [2, 3];
  const row3 = [4, 5, 6];
  const row4 = [7, 8, 9, 10];
  bool sameRowAdjacent(List<int> row) {
    final idxA = row.indexOf(a);
    final idxB = row.indexOf(b);
    return idxA != -1 && idxB != -1 && (idxA - idxB).abs() == 1;
  }
  if (sameRowAdjacent(row2) || sameRowAdjacent(row3) || sameRowAdjacent(row4)) {
    return true;
  }
  // 斜對角相鄰：上層的每瓶與下層左右相鄰
  final Map<int, List<int>> diag = {
    1: [2, 3],
    2: [4, 5],
    3: [5, 6],
    4: [7, 8],
    5: [8, 9],
    6: [9, 10],
  };
  bool diagonal(int x, int y) => (diag[x] ?? const []).contains(y) || (diag[y] ?? const []).contains(x);
  return diagonal(a, b);
}

bool _hasAnyAdjacentPair(Set<int> standing) {
  final list = standing.toList();
  for (int i = 0; i < list.length; i++) {
    for (int j = i + 1; j < list.length; j++) {
      if (_areAdjacent(list[i], list[j])) return true;
    }
  }
  return false;
}

bool _hasRowGap(Set<int> standing) {
  // 檢查各排是否存在兩瓶以上且 index 相差 >= 2（表示至少有一個空位）
  const row3 = [4, 5, 6];
  const row4 = [7, 8, 9, 10];

  bool hasGapInRow(List<int> row) {
    final inRow = row.where((p) => standing.contains(p)).toList();
    if (inRow.length < 2) return false;
    inRow.sort();
    for (int i = 0; i < inRow.length - 1; i++) {
      if (inRow[i + 1] - inRow[i] >= 2) return true;
    }
    return false;
  }

  return hasGapInRow(row3) || hasGapInRow(row4);
}

bool _hasFrontClearedAdjacentPair(Set<int> standing, List<bool> firstRollDown) {
  // 定義同排相鄰對應的「正前方」瓶位
  const Map<List<int>, int> frontMap = {
    // 第3排
    [4, 5]: 2,
    [5, 6]: 3,
    // 第4排
    [7, 8]: 4,
    [8, 9]: 5,
    [9, 10]: 6,
  };

  for (final entry in frontMap.entries) {
    final a = entry.key[0];
    final b = entry.key[1];
    final f = entry.value;
    if (standing.contains(a) && standing.contains(b)) {
      final bool frontDown = (f >= 1 && f <= 10) ? firstRollDown[f - 1] : false;
      if (frontDown) return true;
    }
  }
  return false;
}


