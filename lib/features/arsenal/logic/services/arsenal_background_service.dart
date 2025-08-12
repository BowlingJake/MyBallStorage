import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_sort_service.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';
import 'package:flutter/foundation.dart';

/// 使用 Isolate 在背景執行過濾/排序，回傳符合條件的 instance id 清單
class ArsenalBackgroundService {
  ArsenalBackgroundService._();

  static Future<List<int>> computeFilteredSortedIds({
    required List<UserArsenalInstance> instances,
    required int selectedBagNumber,
    String? selectedCategory,
    String searchText = '',
    BallFilters filters = const BallFilters(),
    required SortOption sortOption,
  }) async {
    final lightInstances = instances.map((inst) {
      final ball = inst.bowlingBall;
      return <String, Object?>{
        'id': inst.id,
        'name': ball?.name ?? '',
        'brand': ball?.brand ?? '',
        'coreType': ball?.coreType, // 可能為 null
        'coverstockType': ball?.coverstockType ?? ball?.coverstock,
        'gamesUsed': inst.gamesUsed,
        'addedDateMillis': inst.addedDate.millisecondsSinceEpoch,
        'bag1': inst.bag1 == true,
        'bag2': inst.bag2 == true,
        'bag3': inst.bag3 == true,
        'bag4': inst.bag4 == true,
        'bag5': inst.bag5 == true,
        'bag6': inst.bag6 == true,
        'bag7': inst.bag7 == true,
        'bag8': inst.bag8 == true,
        'bag9': inst.bag9 == true,
      };
    }).toList(growable: false);

    final args = <String, Object?>{
      'instances': lightInstances,
      'selectedBagNumber': selectedBagNumber,
      'selectedCategory': selectedCategory,
      'searchText': searchText,
      'filters': <String, Object?>{
        'brands': filters.brands.toList(growable: false),
        'cores': filters.cores.toList(growable: false),
        'coverstocks': filters.coverstocks.toList(growable: false),
      },
      'sortOption': sortOption.name,
    };

    return compute(_filterAndSortIds, args);
  }
}

List<int> _filterAndSortIds(Map<String, Object?> args) {
  final instances = (args['instances'] as List).cast<Map<String, Object?>>();
  final selectedBagNumber = args['selectedBagNumber'] as int;
  final searchText = (args['searchText'] as String).toLowerCase();
  final sortOptionName = args['sortOption'] as String;
  final filters = (args['filters'] as Map<String, Object?>);
  final selectedBrands = ((filters['brands'] as List?) ?? const <Object?>[]).cast<String>().toSet();
  final selectedCores = ((filters['cores'] as List?) ?? const <Object?>[]).cast<String>().toSet();
  final selectedCoverstocks = ((filters['coverstocks'] as List?) ?? const <Object?>[]).cast<String>().toSet();

  bool isInBag(Map<String, Object?> m, int bag) {
    switch (bag) {
      case 1:
        return true; // 1 代表 All My Arsenal
      case 2:
        return (m['bag2'] as bool?) ?? false;
      case 3:
        return (m['bag3'] as bool?) ?? false;
      case 4:
        return (m['bag4'] as bool?) ?? false;
      case 5:
        return (m['bag5'] as bool?) ?? false;
      case 6:
        return (m['bag6'] as bool?) ?? false;
      case 7:
        return (m['bag7'] as bool?) ?? false;
      case 8:
        return (m['bag8'] as bool?) ?? false;
      case 9:
        return (m['bag9'] as bool?) ?? false;
      default:
        return (m['bag1'] as bool?) ?? false;
    }
  }

  String normalizeCoreType(String? raw) {
    if (raw == null) return '';
    return raw.toLowerCase().contains('asym') ? 'Asymmetric' : 'Symmetric';
  }

  bool matchesSearch(Map<String, Object?> m) {
    if (searchText.isEmpty) return true;
    final name = (m['name'] as String).toLowerCase();
    final brand = (m['brand'] as String).toLowerCase();
    return name.contains(searchText) || brand.contains(searchText);
  }

  final filtered = instances.where((m) {
    if (!isInBag(m, selectedBagNumber)) return false;
    if (!matchesSearch(m)) return false;
    if (selectedBrands.isNotEmpty && !selectedBrands.contains(m['brand'])) return false;
    if (selectedCores.isNotEmpty && !selectedCores.contains(normalizeCoreType(m['coreType'] as String?))) return false;
    if (selectedCoverstocks.isNotEmpty && !selectedCoverstocks.contains(m['coverstockType'])) return false;
    return true;
  }).toList(growable: false);

  int compareByString(String a, String b, {required bool ascending}) {
    final c = a.compareTo(b);
    return ascending ? c : -c;
  }

  int compareByInt(int a, int b, {required bool ascending}) {
    final c = a.compareTo(b);
    return ascending ? c : -c;
  }

  int compareByDate(int aMillis, int bMillis, {required bool ascending}) {
    final c = aMillis.compareTo(bMillis);
    return ascending ? c : -c;
  }

  int Function(Map<String, Object?>, Map<String, Object?>) comparator;

  switch (sortOptionName) {
    case 'nameAZ':
      comparator = (a, b) => compareByString((a['name'] as String), (b['name'] as String), ascending: true);
      break;
    case 'nameZA':
      comparator = (a, b) => compareByString((a['name'] as String), (b['name'] as String), ascending: false);
      break;
    case 'brandAZ':
      comparator = (a, b) => compareByString((a['brand'] as String), (b['brand'] as String), ascending: true);
      break;
    case 'brandZA':
      comparator = (a, b) => compareByString((a['brand'] as String), (b['brand'] as String), ascending: false);
      break;
    case 'dateNewest':
      comparator = (a, b) => compareByDate((a['addedDateMillis'] as int), (b['addedDateMillis'] as int), ascending: false);
      break;
    case 'dateOldest':
      comparator = (a, b) => compareByDate((a['addedDateMillis'] as int), (b['addedDateMillis'] as int), ascending: true);
      break;
    case 'gamesUsedMost':
      comparator = (a, b) => compareByInt((a['gamesUsed'] as int), (b['gamesUsed'] as int), ascending: false);
      break;
    case 'gamesUsedLeast':
      comparator = (a, b) => compareByInt((a['gamesUsed'] as int), (b['gamesUsed'] as int), ascending: true);
      break;
    default:
      comparator = (a, b) => 0;
  }

  filtered.sort(comparator);

  return filtered.map<int>((m) => m['id'] as int).toList(growable: false);
}


