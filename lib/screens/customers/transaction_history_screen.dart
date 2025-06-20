import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hisab_kitab/data/models/transaction_model.dart';
import 'package:hisab_kitab/data/models/customer_model.dart';
import 'package:hisab_kitab/constants/app_colors.dart';
import 'package:hisab_kitab/constants/app_text_style.dart';

class TransactionHistoryScreen extends StatelessWidget {
  final Customer customer;

  const TransactionHistoryScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final transactionBox = Hive.box<TransactionModel>('transactions');

    // Filter transactions related to this customer
    final transactions = transactionBox.values
        .where((tx) => tx.customerId == customer.id)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        title:  Text('Transaction History'.tr(), style: AppTextStyle.heading2),
        centerTitle: true,
      ),
      body: transactions.isEmpty
          ? Center(
              child: Text('No transactions found.'.tr(), style: AppTextStyle.body1),
            )
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return ListTile(
                  leading: Icon(
                    tx.amount >= 0 ? Icons.arrow_downward : Icons.arrow_upward,
                    color: tx.amount >= 0 ? AppColors.income : AppColors.expense,
                  ),
                  title: Text(
                    '₹${tx.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: tx.amount >= 0 ? AppColors.income : AppColors.expense,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    tx.date.toLocal().toString().split(' ')[0],
                    style: AppTextStyle.body2,
                  ),
                );
              },
            ),
    );
  }
}
