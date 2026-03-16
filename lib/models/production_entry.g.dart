// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_entry.dart';

class ProductionEntryAdapter extends TypeAdapter<ProductionEntry> {
  @override
  final int typeId = 1;

  @override
  ProductionEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductionEntry(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      machineNumber: fields[2] as String,
      designNumber: fields[3] as String,
      workerName: fields[4] as String,
      piecesCompleted: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProductionEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.machineNumber)
      ..writeByte(3)
      ..write(obj.designNumber)
      ..writeByte(4)
      ..write(obj.workerName)
      ..writeByte(5)
      ..write(obj.piecesCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductionEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
