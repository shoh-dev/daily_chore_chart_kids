// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chore.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChoreAdapter extends TypeAdapter<Chore> {
  @override
  final int typeId = 1;

  @override
  Chore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chore(
      id: fields[0] as String,
      title: fields[1] as String,
      iconPath: fields[2] as String,
      isCompleted: fields[3] as bool,
      isPremium: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Chore obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.iconPath)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.isPremium);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
