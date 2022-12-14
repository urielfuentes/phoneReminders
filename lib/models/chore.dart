import 'package:hive_flutter/hive_flutter.dart';
part 'chore.g.dart';

@HiveType(typeId: 0)
class Chore {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String description;
  @HiveField(4)
  String tag;
  @HiveField(5)
  DateTime expiryDate;

  Chore(this.id, this.name, this.description, this.tag, this.expiryDate);
}
