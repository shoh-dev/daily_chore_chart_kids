// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sticker.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StickerAdapter extends TypeAdapter<Sticker> {
  @override
  final int typeId = 2;

  @override
  Sticker read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sticker(
      id: fields[0] as String,
      name: fields[1] as String,
      imagePath: fields[2] as String,
      earned: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Sticker obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.earned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StickerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
