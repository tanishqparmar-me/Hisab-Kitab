import 'package:hive/hive.dart';

part 'customer_model.g.dart';

@HiveType(typeId: 0)
class Customer {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String phone;

  @HiveField(3)
  double balance;

  @HiveField(4)
  DateTime lastUpdated;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.balance,
    required this.lastUpdated,
  });
}
