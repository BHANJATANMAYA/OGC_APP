import 'package:hive/hive.dart';

part 'production_entry.g.dart';

@HiveType(typeId: 1)
class ProductionEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String machineNumber;

  @HiveField(3)
  String designNumber;

  @HiveField(4)
  String workerName;

  @HiveField(5)
  int piecesCompleted;

  ProductionEntry({
    required this.id,
    required this.date,
    required this.machineNumber,
    required this.designNumber,
    required this.workerName,
    required this.piecesCompleted,
  });
}
