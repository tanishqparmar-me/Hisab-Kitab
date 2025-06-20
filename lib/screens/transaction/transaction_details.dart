import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hisab_kitab/screens/transaction/update_transaction_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hisab_kitab/constants/app_colors.dart';
import 'package:hisab_kitab/constants/app_text_style.dart';
import 'package:hisab_kitab/data/models/customer_model.dart';
import 'package:hisab_kitab/data/models/transaction_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TransactionDetailScreen extends StatefulWidget {
  final TransactionModel transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  late TransactionModel transaction;

  @override
  void initState() {
    super.initState();
    transaction = widget.transaction;
  }

  void refreshTransaction() {
    final transactionBox = Hive.box<TransactionModel>('transactions');
    final updated = transactionBox.values.firstWhere(
      (t) => t.id == widget.transaction.id,
      orElse: () => widget.transaction,
    );
    setState(() {
      transaction = updated;
    });
  }

  void launchWhatsAppReminder(
    BuildContext context,
    String phone,
    String name,
    double amount,
  ) async {
    final msg =
        'Hi '.tr() +
        name.toString() +
        ', this is a reminder that you owe me ₹'.tr() +
        amount.toStringAsFixed(2).toString() +
        '. Please pay it as soon as possible.'.tr();
    final encodedMsg = Uri.encodeComponent(msg);
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    final Uri url = Uri.parse("https://wa.me/91$cleanPhone?text=$encodedMsg");
    launchUrl(url);
  }

  Future<void> deleteTransaction(BuildContext context) async {
    final transactionBox = Hive.box<TransactionModel>('transactions');
    final allTransactions = transactionBox.values.toList();

    final index = allTransactions.indexWhere(
      (t) =>
          t.amount == transaction.amount &&
          t.date == transaction.date &&
          t.customerId == transaction.customerId &&
          t.type == transaction.type &&
          t.note == transaction.note,
    );

    if (index == -1) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Transaction not found.".tr())));
      return;
    }

    final key = transactionBox.keyAt(index);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Transaction".tr()),
        content: Text("Are you sure you want to delete this transaction?".tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel".tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text("Delete".tr()),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await transactionBox.delete(key);
      if(!mounted)return;
      Navigator.pop(this.context);
      ScaffoldMessenger.of(
        this.context,
      ).showSnackBar(SnackBar(content: Text("Transaction deleted".tr())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerBox = Hive.box<Customer>('customers');
    final customer = customerBox.values.firstWhere(
      (c) => c.id == transaction.customerId,
      orElse: () => Customer(
        id: '',
        name: 'Unknown'.tr(),
        phone: '',
        balance: 0,
        lastUpdated: DateTime.now(),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Details'.tr(), style: AppTextStyle.heading2),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    transaction.type == 'credit'
                        ? Icons.call_received
                        : Icons.call_made,
                    size: 48,
                    color: transaction.type == 'credit'
                        ? AppColors.income
                        : AppColors.expense,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    transaction.type.toUpperCase(),
                    style: AppTextStyle.heading2.copyWith(
                      color: transaction.type == 'credit'
                          ? AppColors.income
                          : AppColors.expense,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '₹${transaction.amount.toStringAsFixed(2)}',
                    style: AppTextStyle.heading1.copyWith(
                      color: transaction.type == 'credit'
                          ? AppColors.income
                          : AppColors.expense,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Divider(color: AppColors.grey.withAlpha((0.1 * 255).toInt())),
                  const SizedBox(height: 12),
                  _buildTile(Icons.person, 'Customer'.tr(), customer.name),
                  const SizedBox(height: 12),
                  _buildTile(
                    Icons.calendar_month,
                    'Date'.tr(),
                    DateFormat.yMMMMd().add_jm().format(transaction.date),
                  ),
                  if (transaction.note.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildTile(Icons.note, 'Note'.tr(), transaction.note),
                  ],
                  const SizedBox(height: 24),

                  if (transaction.type == 'debit' && customer.phone.isNotEmpty)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.call),
                      label: Text('Send Reminder on WhatsApp'.tr()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: AppTextStyle.buttonText,
                      ),
                      onPressed: () {
                        launchWhatsAppReminder(
                          context,
                          customer.phone,
                          customer.name,
                          transaction.amount,
                        );
                      },
                    ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.delete),
                          label: Text('Delete'.tr()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => deleteTransaction(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: Text('Edit'.tr()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateTransactionScreen(
                                  transaction: transaction,
                                ),
                              ),
                            );

                            if (result is TransactionModel) {
                              setState(() {
                                transaction = result;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.body2.copyWith(color: AppColors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyle.body1.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
