// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inward_entry.dart';

class InwardEntryAdapter extends TypeAdapter<InwardEntry> {
  @override
  final int typeId = 0;

  @override
  InwardEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InwardEntry(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      partyName: fields[2] as String,
      fabricType: fields[3] as String,
      quantityReceived: fields[4] as double,
      unit: fields[5] as String,
      designNumber: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, InwardEntry obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.partyName)
      ..writeByte(3)
      ..write(obj.fabricType)
      ..writeByte(4)
      ..write(obj.quantityReceived)
      ..writeByte(5)
      ..write(obj.unit)
      ..writeByte(6)
      ..write(obj.designNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InwardEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
