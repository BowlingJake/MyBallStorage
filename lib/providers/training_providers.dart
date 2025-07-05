import 'package:bowlingarsenal_app/shared/enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final trainingTabProvider = StateProvider<BottomNavTab>(
  (ref) => BottomNavTab.training,
); 