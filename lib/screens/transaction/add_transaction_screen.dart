import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hisab_kitab/constants/app_colors.dart';
import 'package:hisab_kitab/constants/app_text_style.dart';
import 'package:hisab_kitab/data/models/customer_model.dart';
import 'package:hisab_kitab/data/models/transaction_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _transactionType = 'credit';
  Customer? _selectedCustomer;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submitTransaction() {
    if (!_formKey.currentState!.validate()) return;

    final txnBox = Hive.box<TransactionModel>('transactions');
    final customerBox = Hive.box<Customer>('customers');
    final customer = _selectedCustomer!;
    final amount = double.parse(_amountController.text.trim());
    final note = _noteController.text.trim();

    final transaction = TransactionModel(
      id: const Uuid().v4(),
      customerId: customer.id,
      amount: amount,
      type: _transactionType,
      note: note,
      date: DateTime.now(),
    );

    txnBox.add(transaction);

    final customerKey = customerBox.keys.firstWhere(
      (key) => customerBox.get(key)!.id == customer.id,
      orElse: () => null,
    );

    if (customerKey != null) {
      final updatedCustomer = Customer(
        id: customer.id,
        name: customer.name,
        phone: customer.phone,
        balance: customer.balance + (_transactionType == 'credit' ? amount : -amount),
        lastUpdated: DateTime.now(),
      );
      customerBox.put(customerKey, updatedCustomer);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final customerBox = Hive.box<Customer>('customers');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -60,
              right: -40,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(25),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text('Add Transaction'.tr(), style: AppTextStyle.heading1),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            DropdownButtonFormField<Customer>(
                              decoration: InputDecoration(
                                labelText: 'Select Customer'.tr(),
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: customerBox.values.map((customer) {
                                return DropdownMenuItem<Customer>(
                                  value: customer,
                                  child: Text(customer.name),
                                );
                              }).toList(),
                              onChanged: (value) => setState(() {
                                _selectedCustomer = value;
                              }),
                              validator: (value) =>
                                  value == null ? 'Please select a customer'.tr() : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Amount'.tr(),
                                prefixIcon: const Icon(Icons.currency_rupee),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Amount is required'.tr();
                                }
                                if (double.tryParse(value.trim()) == null) {
                                  return 'Enter a valid number'.tr();
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _noteController,
                              decoration: InputDecoration(
                                labelText: 'Note (optional)'.tr(),
                                prefixIcon: const Icon(Icons.note_alt_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile(
                                    title: Text('Credit'.tr()),
                                    value: 'credit',
                                    groupValue: _transactionType,
                                    onChanged: (value) {
                                      setState(() {
                                        _transactionType = value!;
                                      });
                                    },
                                    activeColor: AppColors.primary,
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    title: Text('Debit'.tr()),
                                    value: 'debit',
                                    groupValue: _transactionType,
                                    onChanged: (value) {
                                      setState(() {
                                        _transactionType = value!;
                                      });
                                    },
                                    activeColor: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.add_card_outlined),
                                label: Text(
                                  'Add Transaction'.tr(),
                                  style: AppTextStyle.buttonText,
                                ),
                                onPressed: _submitTransaction,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
