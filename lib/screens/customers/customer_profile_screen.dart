import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hisab_kitab/screens/customers/update_customer_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hisab_kitab/constants/app_colors.dart';
import 'package:hisab_kitab/constants/app_text_style.dart';
import 'package:hisab_kitab/data/models/customer_model.dart';
import 'package:hisab_kitab/data/models/transaction_model.dart';
import 'package:hisab_kitab/screens/transaction/add_transaction_screen.dart';

class CustomerProfileScreen extends StatefulWidget {
  final Customer customer;

  const CustomerProfileScreen({super.key, required this.customer});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  late Customer customer;
  List<MapEntry<dynamic, TransactionModel>> customerTransactions = [];

  @override
  void initState() {
    super.initState();
    customer = widget.customer;
    loadData();
  }

  void loadData() {
    final transactionBox = Hive.box<TransactionModel>('transactions');
    final customerBox = Hive.box<Customer>('customers');

    // Refresh customer data in case it changed
    final key = customerBox.keys.firstWhere(
      (k) => customerBox.get(k)?.id == customer.id,
      orElse: () => null,
    );
    if (key != null) {
      final freshCustomer = customerBox.get(key);
      if (freshCustomer != null) {
        customer = freshCustomer;
      }
    }

    // Get customer transactions
    customerTransactions =
        transactionBox.keys
            .map((key) => MapEntry(key, transactionBox.get(key)!))
            .where((entry) => entry.value.customerId == customer.id)
            .toList()
          ..sort((a, b) => b.value.date.compareTo(a.value.date));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final transactionBox = Hive.box<TransactionModel>('transactions');
    final customerBox = Hive.box<Customer>('customers');

    return SafeArea(
    top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(customer.name, style: AppTextStyle.heading2),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh'.tr(),
              onPressed: loadData,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.primary.withAlpha((0.1 * 255).toInt()),
                        child: const Icon(
                          Icons.person,
                          size: 36,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(customer.name, style: AppTextStyle.heading2),
                      const SizedBox(height: 8),
                      Text(customer.phone, style: AppTextStyle.body2),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.account_balance_wallet,
                            size: 20,
                            color: AppColors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Balance: ₹'.tr() +
                                customer.balance.toStringAsFixed(2).toString(),
                            style: customer.balance >= 0
                                ? AppTextStyle.balancePositive
                                : AppTextStyle.balanceNegative,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Last Updated: '.tr() +
                            DateFormat.yMMMEd()
                                .format(customer.lastUpdated)
                                .toString(),
                        style: AppTextStyle.body2.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Transaction History
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Transaction History'.tr(),
                  style: AppTextStyle.heading2,
                ),
              ),
              const SizedBox(height: 12),
              if (customerTransactions.isEmpty)
                Text("No transactions yet".tr(), style: AppTextStyle.body2)
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: customerTransactions.length,
                  itemBuilder: (context, index) {
                    final entry = customerTransactions[index];
                    final transaction = entry.value;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        transaction.type == 'credit'
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: transaction.type == 'credit'
                            ? AppColors.income
                            : AppColors.expense,
                      ),
                      title: Text(
                        '₹${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: transaction.type == 'credit'
                              ? AppColors.income
                              : AppColors.expense,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat.yMMMd().add_jm().format(transaction.date),
                      ),
                      trailing: Text(
                        transaction.note,
                        style: AppTextStyle.body2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),

              const SizedBox(height: 30),

              // Add Transaction Button
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddTransactionScreen(),
                          ),
                        ).then((_) => loadData());
                      },
                      icon: const Icon(Icons.add),
                      label: Text('Add Transaction'.tr()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: AppTextStyle.buttonText,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Edit & Delete Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                UpdateCustomerScreen(customer: customer),
                          ),
                        ).then((_) => loadData());
                      },
                      icon: const Icon(Icons.edit, color: AppColors.primary),
                      label: Text('Edit'.tr()),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Delete Customer?".tr()),
                            content: Text(
                              "This will permanently remove the customer and all their transactions."
                                  .tr(),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text("Cancel".tr()),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  "Delete".tr(),
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          for (final entry in customerTransactions) {
                            await transactionBox.delete(entry.key);
                          }

                          final keyToDelete = customerBox.keys.firstWhere(
                            (key) => customerBox.get(key)?.id == customer.id,
                            orElse: () => null,
                          );

                          if (keyToDelete != null) {
                            await customerBox.delete(keyToDelete);
                            if(!mounted)return;
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(content: Text('Customer deleted'.tr())),
                            );
                            Navigator.pop(this.context);
                          }
                        }
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: Text('Delete'.tr()),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
