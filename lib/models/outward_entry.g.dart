// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outward_entry.dart';

class OutwardEntryAdapter extends TypeAdapter<OutwardEntry> {
  @override
  final int typeId = 2;

  @override
  OutwardEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OutwardEntry(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      designNumber: fields[2] as String,
      totalPiecesSent: fields[3] as int,
      challanNumber: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OutwardEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.designNumber)
      ..writeByte(3)
      ..write(obj.totalPiecesSent)
      ..writeByte(4)
      ..write(obj.challanNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OutwardEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
