import 'package:hive/hive.dart';

part 'inward_entry.g.dart';

@HiveType(typeId: 0)
class InwardEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String partyName;

  @HiveField(3)
  String fabricType;

  @HiveField(4)
  double quantityReceived;

  @HiveField(5)
  String unit; // 'Meters' or 'Pieces'

  @HiveField(6)
  String designNumber;

  InwardEntry({
    required this.id,
    required this.date,
    required this.partyName,
    required this.fabricType,
    required this.quantityReceived,
    required this.unit,
    required this.designNumber,
  });
}
