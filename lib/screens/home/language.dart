import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hisab_kitab/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  Future<void> _setLanguage(BuildContext context, String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', langCode);

    if (!context.mounted) return;
    await context.setLocale(Locale(langCode));

    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Restart Required".tr()),
        content: Text("The app will restart to apply language changes.".tr()),
        actions: [
          TextButton(
            onPressed: () => exit(0),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languages = [
      {'code': 'en', 'name': 'English', 'flag': '𝗘𝗡'},
      {'code': 'hi', 'name': 'हिन्दी', 'flag': 'ૐ'},
      {'code': 'mr', 'name': 'मराठी', 'flag': '⚜'},
      {'code': 'ur', 'name': 'اردو', 'flag': '☪︎'},
      {'code': 'pb', 'name': 'ਪੰਜਾਬੀ', 'flag': '☬'},
      {'code': 'ml', 'name': 'मालवी', 'flag': '𓅭'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Select Language'.tr(),
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: languages.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final lang = languages[index];
          return GestureDetector(
            onTap: () => _setLanguage(context, lang['code']!),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 255, 208, 37),
                    Color.fromARGB(255, 255, 166, 93),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white24,
                    radius: 22,
                    child: Text(
                      lang['flag']!,
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      lang['name']!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white70, size: 18),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
