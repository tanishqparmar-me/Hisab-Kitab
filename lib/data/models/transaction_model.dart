import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 1)
class TransactionModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String customerId;

  @HiveField(2)
  double amount;

  @HiveField(3)
  String type; // 'credit' or 'debit'

  @HiveField(4)
  String note;

  @HiveField(5)
  DateTime date;

  TransactionModel({
    required this.id,
    required this.customerId,
    required this.amount,
    required this.type,
    required this.note,
    required this.date,
  });
}
