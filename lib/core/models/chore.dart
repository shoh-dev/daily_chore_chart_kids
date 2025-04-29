import 'package:hive/hive.dart';

part 'chore.g.dart';

@HiveType(typeId: 1)
class Chore extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String iconPath;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  final bool isPremium;

  Chore({
    required this.id,
    required this.title,
    required this.iconPath,
    this.isCompleted = false,
    this.isPremium = false,
  });
}
