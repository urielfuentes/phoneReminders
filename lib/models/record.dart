import 'package:hive_flutter/hive_flutter.dart';
part 'record.g.dart';

@HiveType(typeId: 1)
class Record {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String description;
  @HiveField(3)
  DateTime entryDate;
  @HiveField(4)
  String tag;

  Record(this.id, this.name, this.description, this.entryDate, this.tag);
}
