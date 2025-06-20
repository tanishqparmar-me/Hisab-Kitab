import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hisab_kitab/constants/app_colors.dart';
import 'package:hisab_kitab/constants/app_text_style.dart';
import 'package:hisab_kitab/data/models/customer_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UpdateCustomerScreen extends StatefulWidget {
  final Customer customer;

  const UpdateCustomerScreen({super.key, required this.customer});

  @override
  State<UpdateCustomerScreen> createState() => _UpdateCustomerScreenState();
}

class _UpdateCustomerScreenState extends State<UpdateCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer.name);
    _phoneController = TextEditingController(text: widget.customer.phone);
  }

  void _updateCustomer() async {
    if (_formKey.currentState!.validate()) {
      final customerBox = Hive.box<Customer>('customers');

      final keyToUpdate = customerBox.keys.firstWhere(
        (key) => customerBox.get(key)?.id == widget.customer.id,
        orElse: () => null,
      );

      if (keyToUpdate != null) {
        final updatedCustomer = Customer(
          id: widget.customer.id,
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          balance: widget.customer.balance,
          lastUpdated: DateTime.now(),
        );

        await customerBox.put(keyToUpdate, updatedCustomer);
        if(!mounted)return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Customer updated successfully'.tr())),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Customer'.tr(), style: AppTextStyle.heading2),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Icon(Icons.person_pin, size: 80, color: AppColors.primary.withAlpha((0.1 * 255).toInt())),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name'.tr(),
                  prefixIcon: const Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone'.tr(),
                  prefixIcon: const Icon(Icons.phone),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Please enter phone number'.tr();
                  if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) return 'Enter valid 10-digit phone'.tr();
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _updateCustomer,
                icon: const Icon(Icons.save),
                label: Text('Save Changes'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: AppTextStyle.buttonText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
