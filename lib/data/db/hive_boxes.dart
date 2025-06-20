import 'package:hive_flutter/hive_flutter.dart';
import 'package:hisab_kitab/data/models/customer_model.dart';

class HiveBoxes {
  static const String customersBox = 'customers';

  static Box<Customer> getCustomersBox() =>
      Hive.box<Customer>(customersBox);
}
