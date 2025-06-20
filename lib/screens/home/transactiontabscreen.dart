import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hisab_kitab/screens/transaction/add_transaction_screen.dart';
import 'package:hisab_kitab/screens/transaction/transaction_details.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hisab_kitab/data/models/transaction_model.dart';
import 'package:hisab_kitab/data/models/customer_model.dart';
import 'package:hisab_kitab/constants/app_colors.dart';
import 'package:hisab_kitab/constants/app_text_style.dart';

class TransactionTabScreen extends StatefulWidget {
  const TransactionTabScreen({super.key});

  @override
  State<TransactionTabScreen> createState() => _TransactionTabScreenState();
}

class _TransactionTabScreenState extends State<TransactionTabScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final transactionBox = Hive.box<TransactionModel>('transactions');
    final customerBox = Hive.box<Customer>('customers');

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: transactionBox.listenable(),
        builder: (context, Box<TransactionModel> box, _) {
          if (box.isEmpty) {
            return  Center(
              child: Text('No transactions yet.'.tr(), style: AppTextStyle.body1),
            );
          }

          final allTransactions = box.values.toList()
            ..sort((a, b) => b.date.compareTo(a.date)); // Latest first

          final filteredTransactions = allTransactions.where((transaction) {
            final customer = customerBox.values.firstWhere(
              (c) => c.id == transaction.customerId,
              orElse: () => Customer(
                id: '',
                name: 'Unknown'.tr(),
                phone: '',
                balance: 0.0,
                lastUpdated: DateTime.now(),
              ),
            );
            return customer.name.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by customer name...'.tr(),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.grey.withAlpha((0.1 * 255).toInt()),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.trim();
                    });
                  },
                ),
              ),
              Expanded(
                child: filteredTransactions.isEmpty
                    ? Center(
                        child: Text('No matching transactions found.'.tr(), style: AppTextStyle.body1),
                      )
                    : ListView.builder(
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = filteredTransactions[index];

                          final customer = customerBox.values.firstWhere(
                            (c) => c.id == transaction.customerId,
                            orElse: () => Customer(
                              id: '',
                              name: 'Unknown'.tr(),
                              phone: '',
                              balance: 0.0,
                              lastUpdated: DateTime.now(),
                            ),
                          );

                          final isCredit = transaction.type == 'credit';

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => TransactionDetailScreen(transaction: transaction),
                                  ),
                                );
                              },
                              title: Text(customer.name, style: AppTextStyle.body1),
                              subtitle: Text(
                                DateFormat.yMMMEd().add_jm().format(transaction.date),
                                style: AppTextStyle.body2,
                              ),
                              trailing: Text(
                                (isCredit ? '+ ₹' : '- ₹') + transaction.amount.toStringAsFixed(2),
                                style: TextStyle(
                                  color: isCredit ? AppColors.income : AppColors.expense,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        tooltip: 'Add Transaction'.tr(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
