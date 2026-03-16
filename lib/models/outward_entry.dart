import 'package:hive/hive.dart';

part 'outward_entry.g.dart';

@HiveType(typeId: 2)
class OutwardEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String designNumber;

  @HiveField(3)
  int totalPiecesSent;

  @HiveField(4)
  String challanNumber;

  OutwardEntry({
    required this.id,
    required this.date,
    required this.designNumber,
    required this.totalPiecesSent,
    required this.challanNumber,
  });
}
