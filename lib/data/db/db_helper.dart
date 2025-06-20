import 'package:hisab_kitab/data/db/hive_boxes.dart';
import 'package:hisab_kitab/data/models/customer_model.dart';

class DBHelper {
  /// Add a new customer
  static Future<void> addCustomer(Customer customer) async {
    final box = HiveBoxes.getCustomersBox();
    await box.add(customer);
  }

  /// Update a customer
  static Future<void> updateCustomer(int index, Customer updatedCustomer) async {
    final box = HiveBoxes.getCustomersBox();
    await box.putAt(index, updatedCustomer);
  }

  /// Delete a customer
  static Future<void> deleteCustomer(int index) async {
    final box = HiveBoxes.getCustomersBox();
    await box.deleteAt(index);
  }

  /// Get all customers as a list
  static List<Customer> getAllCustomers() {
    final box = HiveBoxes.getCustomersBox();
    return box.values.toList();
  }

  /// Clear all customers
  static Future<void> clearAllCustomers() async {
    final box = HiveBoxes.getCustomersBox();
    await box.clear();
  }

  /// Get customer by index
  static Customer getCustomer(int index) {
    final box = HiveBoxes.getCustomersBox();
    return box.getAt(index)!;
  }

  /// Get total balance
  static double getTotalBalance() {
    return getAllCustomers().fold(0.0, (sum, customer) => sum + customer.balance);
  }
}
