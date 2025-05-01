import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../utils/hive_keys.dart';

final premiumProvider = StateProvider<bool>((ref) {
  return Hive.box(HiveBoxKeys.appState).get(HiveBoxKeys.hasPremium) ?? false;
});
