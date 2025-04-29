import 'package:hive/hive.dart';

part 'kid_profile.g.dart';

@HiveType(typeId: 0)
class KidProfile extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String avatarPath;

  @HiveField(3)
  final List<String> earnedStickerIds;

  KidProfile({
    required this.id,
    required this.name,
    required this.avatarPath,
    this.earnedStickerIds = const [],
  });
}
