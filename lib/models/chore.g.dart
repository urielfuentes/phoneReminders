// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chore.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChoreAdapter extends TypeAdapter<Chore> {
  @override
  final int typeId = 0;

  @override
  Chore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chore(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[4] as String,
      fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Chore obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.tag)
      ..writeByte(5)
      ..write(obj.expiryDate);
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
