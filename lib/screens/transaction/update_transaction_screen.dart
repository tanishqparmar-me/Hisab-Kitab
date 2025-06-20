import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hisab_kitab/constants/app_colors.dart';
import 'package:hisab_kitab/constants/app_text_style.dart';
import 'package:hisab_kitab/data/models/transaction_model.dart';
import 'package:hisab_kitab/data/models/customer_model.dart';
import 'package:hive/hive.dart';

class UpdateTransactionScreen extends StatefulWidget {
  final TransactionModel transaction;

  const UpdateTransactionScreen({super.key, required this.transaction});

  @override
  State<UpdateTransactionScreen> createState() => _UpdateTransactionScreenState();
}

class _UpdateTransactionScreenState extends State<UpdateTransactionScreen> {
  late TextEditingController amountController;
  late TextEditingController noteController;
  late String transactionType;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(text: widget.transaction.amount.toString());
    noteController = TextEditingController(text: widget.transaction.note);
    transactionType = widget.transaction.type;
  }

  Future<void> updateTransaction() async {
    final newAmount = double.tryParse(amountController.text.trim());
    if (newAmount == null || newAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Enter a valid amount".tr())),
      );
      return;
    }

    final txnBox = Hive.box<TransactionModel>('transactions'.tr());
    final customerBox = Hive.box<Customer>('customers'.tr());

    // Find transaction key
    final txnKey = txnBox.keys.firstWhere(
      (k) => txnBox.get(k)?.id == widget.transaction.id,
      orElse: () => null,
    );

    if (txnKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Transaction not found.".tr())),
      );
      return;
    }

    final customerKey = customerBox.keys.firstWhere(
      (k) => customerBox.get(k)?.id == widget.transaction.customerId,
      orElse: () => null,
    );

    if (customerKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Customer not found.".tr())),
      );
      return;
    }

    final oldTxn = widget.transaction;
    final customer = customerBox.get(customerKey)!;

    // Revert old transaction effect
    double balance = customer.balance;
    balance -= oldTxn.type == 'credit'.tr() ? oldTxn.amount : -oldTxn.amount;

    // Apply new transaction effect
    balance += transactionType == 'credit'.tr() ? newAmount : -newAmount;

    // Save updated customer balance
    final updatedCustomer = Customer(
      id: customer.id,
      name: customer.name,
      phone: customer.phone,
      balance: balance,
      lastUpdated: DateTime.now(),
    );
    await customerBox.put(customerKey, updatedCustomer);

    // Save updated transaction
    final updatedTransaction = TransactionModel(
      id: oldTxn.id,
      customerId: oldTxn.customerId,
      amount: newAmount,
      type: transactionType,
      note: noteController.text.trim(),
      date: oldTxn.date,
    );
    await txnBox.put(txnKey, updatedTransaction);
    if(!mounted)return;
    Navigator.pop(context, updatedTransaction);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Transaction updated successfully".tr())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Edit Transaction".tr(), style: AppTextStyle.heading2),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text("Credit"),
                    value: 'credit',
                    groupValue: transactionType,
                    onChanged: (value) => setState(() => transactionType = value.toString()),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text("Debit"),
                    value: 'debit',
                    groupValue: transactionType,
                    onChanged: (value) => setState(() => transactionType = value.toString()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Update", style: AppTextStyle.buttonText),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
