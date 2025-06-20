import 'package:flutter/material.dart';
import 'package:hisab_kitab/constants/app_colors.dart';
import 'package:hisab_kitab/constants/app_text_style.dart';
import 'package:hisab_kitab/constants/app_button_style.dart';
import 'package:hisab_kitab/screens/home/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hisab_kitab/screens/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HisabKitabApp extends StatefulWidget {
  const HisabKitabApp({super.key});

  @override
  State<HisabKitabApp> createState() => _HisabKitabAppState();
}

class _HisabKitabAppState extends State<HisabKitabApp> {
  bool? _seenOnboarding;

  @override
  void initState() {
    super.initState();
    _loadOnboardingStatus();
  }

  Future<void> _loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('seen_onboarding') ?? false;

    setState(() {
      _seenOnboarding = seen;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show splash/loading indicator while checking onboarding status
    if (_seenOnboarding == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      title: 'Hisab Kitab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'main',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          titleTextStyle: AppTextStyle.heading2,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.inputBackground,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          labelStyle: AppTextStyle.inputLabel,
          hintStyle: AppTextStyle.body2,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.inputBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.inputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: AppTextStyle.heading1,
          headlineMedium: AppTextStyle.heading2,
          bodyLarge: AppTextStyle.body1,
          bodyMedium: AppTextStyle.body2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(style: AppButtonStyle.elevated),
        outlinedButtonTheme: OutlinedButtonThemeData(style: AppButtonStyle.outlined),
        textButtonTheme: TextButtonThemeData(style: AppButtonStyle.textButton),
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: _seenOnboarding! ? const HomeScreen() : const OnboardingScreen(),
    );
  }
}
