import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hisab_kitab/screens/customers/add_customer_screen.dart';
import 'package:hisab_kitab/screens/customers/customer_profile_screen.dart';
import 'package:hisab_kitab/widgets/customer_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hisab_kitab/data/models/customer_model.dart';
import 'package:hisab_kitab/constants/app_text_style.dart';
import 'package:hisab_kitab/constants/app_colors.dart';

// ... [imports remain unchanged]

class CustomerTabScreen extends StatefulWidget {
  const CustomerTabScreen({super.key});

  @override
  State<CustomerTabScreen> createState() => _CustomerTabScreenState();
}

class _CustomerTabScreenState extends State<CustomerTabScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void refreshCustomers() {
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Customer list refreshed".tr())),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerBox = Hive.box<Customer>('customers');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search + Refresh Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.trim().toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search customers...'.tr(),
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: AppColors.grey.withAlpha((0.1 * 255).toInt()),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: refreshCustomers,
                    icon: const Icon(Icons.refresh),
                    color: AppColors.primary,
                    tooltip: "Refresh".tr(),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary.withAlpha((0.1 * 255).toInt()),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),

            // Customer List
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: customerBox.listenable(),
                builder: (context, Box<Customer> box, _) {
                  if (box.isEmpty) {
                    return  Center(
                      child: Text('No customers added yet!'.tr(), style: AppTextStyle.body1),
                    );
                  }

                  final customers = box.values
                      .where((customer) => customer.name.toLowerCase().contains(_searchQuery))
                      .toList();

                  if (customers.isEmpty) {
                    return Center(
                      child: Text('No matching customers found'.tr(), style: AppTextStyle.body2),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];
                      return CustomerTile(
                        customer: customer,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CustomerProfileScreen(customer: customer),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Customer'.tr(),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddCustomerScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white,),
      ),
    );
  }
}
