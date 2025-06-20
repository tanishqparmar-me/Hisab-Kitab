import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hisab_kitab/constants/app_colors.dart';
import 'package:hisab_kitab/constants/app_text_style.dart';
import 'package:hisab_kitab/screens/home/customertabscreen.dart';
import 'package:hisab_kitab/screens/home/drawer.dart';
import 'package:hisab_kitab/screens/home/hometabscreen.dart';
import 'package:hisab_kitab/screens/home/transactiontabscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;



  final List<Widget> _tabs = const [
    HomeTabScreen(),
    CustomerTabScreen(),
    TransactionTabScreen(),
  ];

  final List<String> _titles = [
    'Dashboard'.tr(),
    'Customers'.tr(),
    'Transactions'.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(_titles[_currentIndex], style: AppTextStyle.heading2),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFF9F9F9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _tabs[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTextStyle.body2,
        unselectedLabelStyle: AppTextStyle.body2,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            tooltip: 'Home'.tr(),
            label: 'Home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            tooltip: 'Customers'.tr(),
            label: 'Customers'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            tooltip: 'Transaction'.tr(),
            label: 'Transactions'.tr(),
          ),
        ],
      ),
    );
  }
}