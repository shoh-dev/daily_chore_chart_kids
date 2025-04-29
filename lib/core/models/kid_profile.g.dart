// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kid_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KidProfileAdapter extends TypeAdapter<KidProfile> {
  @override
  final int typeId = 0;

  @override
  KidProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KidProfile(
      id: fields[0] as String,
      name: fields[1] as String,
      avatarPath: fields[2] as String,
      earnedStickerIds: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, KidProfile obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.avatarPath)
      ..writeByte(3)
      ..write(obj.earnedStickerIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KidProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
