import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hisab_kitab/constants/app_colors.dart';
import 'package:hisab_kitab/constants/app_text_style.dart';
import 'package:hisab_kitab/screens/home/about.dart';
import 'package:hisab_kitab/screens/home/language.dart';
import 'package:hisab_kitab/screens/transaction/transictions_table.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 24),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            width: double.infinity,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 34,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: AppColors.primary,
                    size: 34,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Hisab Kitab".tr(),
                  style: AppTextStyle.heading1.copyWith(color: Colors.white),
                ),
                Text(
                  "Track & manage your money".tr(),
                  style: AppTextStyle.body2.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildDrawerItem(
            context,
            icon: Icons.home_rounded,
            title: "Home".tr(),
            onTap: () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.receipt_long_rounded,
            title: "Transactions".tr(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableTransactionScreen()),
              );
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.translate,
            title: "Language".tr(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LanguageSelectionScreen()),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(thickness: 1.2),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.info_outline_rounded,
            title: "About App".tr(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AboutAppScreen()),
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              "v1.0.0 • Made By Tanishq".tr(),
              style: AppTextStyle.body2.copyWith(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          title: Text(title, style: AppTextStyle.body1),
          onTap: onTap,
        ),
      ),
    );
  }
}
