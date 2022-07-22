import 'package:hive_flutter/hive_flutter.dart';
part 'chore.g.dart';

@HiveType(typeId: 0)
class Chore {
  @HiveField(0)
  String name;
  @HiveField(1)
  String description;
  @HiveField(2)
  DateTime expiryDate;

  Chore(this.name, this.description, this.expiryDate);
}
