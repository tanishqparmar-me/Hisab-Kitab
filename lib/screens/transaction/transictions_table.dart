import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hisab_kitab/constants/app_colors.dart';
import 'package:hisab_kitab/constants/app_text_style.dart';
import 'package:hisab_kitab/data/models/customer_model.dart';
import 'package:hisab_kitab/data/models/transaction_model.dart';
import 'package:hisab_kitab/data/services/pdf_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TableTransactionScreen extends StatefulWidget {
  const TableTransactionScreen({super.key});

  @override
  State<TableTransactionScreen> createState() => _TableTransactionScreenState();
}

class _TableTransactionScreenState extends State<TableTransactionScreen> {
  late final Box<TransactionModel> transactionBox;
  late final Box<Customer> customerBox;
  Map<String, Customer> customerMap = {};
  String? selectedCustomerId;

  @override
  void initState() {
    super.initState();
    transactionBox = Hive.box<TransactionModel>('transactions');
    customerBox = Hive.box<Customer>('customers');

    customerMap = {
      for (var customer in customerBox.values) customer.id: customer,
    };
  }

  List<TransactionModel> get filteredTransactions {
    final all = transactionBox.values.toList();
    if (selectedCustomerId == null) return all;
    return all.where((t) => t.customerId == selectedCustomerId).toList();
  }

  void _exportToPDF() async {
    await PDFService.generateTransactionPDF(
      transactions: filteredTransactions,
      customerMap: customerMap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactions = filteredTransactions;


    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("All Transactions".tr(), style: AppTextStyle.heading2),
          backgroundColor: AppColors.primary,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: DropdownButton<String>(
                value: selectedCustomerId,
                isExpanded: true,
                hint:  Text("Filter by Customer".tr()),
                items: customerMap.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCustomerId = value;
                  });
                },
              ),
            ),
            Expanded(
              child: transactions.isEmpty
                  ?  Center(child: Text("No transactions found.".tr()))
                  : Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              AppColors.primary.withAlpha((0.1 * 255).toInt()),
                            ),
                            columns: [
                              DataColumn(label: Text('Customer'.tr())),
                              DataColumn(label: Text('Phone'.tr())),
                              DataColumn(label: Text('Amount'.tr())),
                              DataColumn(label: Text('Type'.tr())),
                              DataColumn(label: Text('Note'.tr())),
                              DataColumn(label: Text('Date'.tr())),
                            ],
                            rows: transactions.map((txn) {
                              final customer = customerMap[txn.customerId];
                              return DataRow(
                                cells: [
                                  DataCell(Text(customer?.name ?? 'Unknown'.tr())),
                                  DataCell(Text(customer?.phone ?? '-')),
                                  DataCell(Text(txn.amount.toStringAsFixed(2))),
                                  DataCell(Text(txn.type)),
                                  DataCell(
                                    Text(txn.note.isNotEmpty ? txn.note : '-'),
                                  ),
                                  DataCell(
                                    Text(
                                      "${txn.date.day}/${txn.date.month}/${txn.date.year}",
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                onPressed: _exportToPDF,
                icon: const Icon(Icons.picture_as_pdf),
                label:  Text("Export to PDF".tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
