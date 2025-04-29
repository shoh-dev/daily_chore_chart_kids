import 'package:hive/hive.dart';
import '../models/kid_profile.dart';
import '../models/chore.dart';
import '../models/sticker.dart';
import '../../utils/hive_keys.dart';

class LocalStorageService {
  final Box<KidProfile> _kidBox = Hive.box<KidProfile>(HiveBoxKeys.kidProfiles);
  final Box<Chore> _choreBox = Hive.box<Chore>(HiveBoxKeys.chores);
  final Box<Sticker> _stickerBox = Hive.box<Sticker>(HiveBoxKeys.stickers);

  // ✅ KID PROFILE
  Future<void> saveKid(KidProfile kid) async {
    await _kidBox.put(kid.id, kid);
  }

  KidProfile? getKid(String id) => _kidBox.get(id);

  List<KidProfile> getAllKids() => _kidBox.values.toList();

  Future<void> deleteKid(String id) async => await _kidBox.delete(id);

  // ✅ CHORES
  Future<void> saveChore(Chore chore) async {
    await _choreBox.put(chore.id, chore);
  }

  List<Chore> getAllChores() => _choreBox.values.toList();

  Future<void> deleteChore(String id) async => await _choreBox.delete(id);

  Future<void> clearAllChores() async => await _choreBox.clear();

  // ✅ STICKERS
  Future<void> saveSticker(Sticker sticker) async {
    await _stickerBox.put(sticker.id, sticker);
  }

  List<Sticker> getAllStickers() => _stickerBox.values.toList();

  Future<void> clearStickers() async => await _stickerBox.clear();
}
