import 'package:hive/hive.dart';

part 'sticker.g.dart';

@HiveType(typeId: 2)
class Sticker extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imagePath;

  @HiveField(3)
  bool earned;

  Sticker({
    required this.id,
    required this.name,
    required this.imagePath,
    this.earned = false,
  });
}
