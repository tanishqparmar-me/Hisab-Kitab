import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hisab_kitab/constants/app_colors.dart';
import 'package:hisab_kitab/constants/app_text_style.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("About App".tr(), style: AppTextStyle.heading2.copyWith(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 70,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Hisab Kitab".tr(),
                    style: AppTextStyle.heading1.copyWith(fontSize: 26),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Version 1.0.0".tr(),
                    style: AppTextStyle.body2.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SectionCard(
              title: "Why This App?".tr(),
              content: "Hisab Kitab is a simple and powerful app designed to help you keep track of money you give and receive from others. Whether you’re a shopkeeper, roommate, or business owner — this app helps you manage transactions efficiently.".tr(),
            ),
            const SizedBox(height: 20),
            SectionCard(
              title: "Key Features".tr(),
              child: Column(
                children: const [
                  FeatureTile(icon: Icons.people, label: "Manage customers"),
                  FeatureTile(icon: Icons.swap_vert, label: "Track credit & debit"),
                  FeatureTile(icon: Icons.pie_chart, label: "Visual charts & stats"),
                  FeatureTile(icon: Icons.share, label: "Send WhatsApp reminders"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SectionCard(
              title: "Made By".tr(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text("Tanishq Parmar", style: AppTextStyle.body1),
                    subtitle: Text("Flutter Developer", style: AppTextStyle.body2),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        launchUrl(Uri.parse('https://www.tanishqparmar.site'));
                      },
                      icon: const Icon(Icons.link),
                      label: Text("View Developer Profile".tr()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "Made By Tanishq in India".tr(),
                style: AppTextStyle.body2.copyWith(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const FeatureTile({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(0),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label.tr(), style: AppTextStyle.body1),
          ),
        ],
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? child;

  const SectionCard({
    super.key,
    required this.title,
    this.content,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyle.heading2),
          const SizedBox(height: 10),
          if (content != null)
            Text(content!, style: AppTextStyle.body1)
          else if (child != null)
            child!,
        ],
      ),
    );
  }
}
