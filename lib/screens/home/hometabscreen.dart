import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hisab_kitab/constants/app_colors.dart';
import 'package:hisab_kitab/constants/app_text_style.dart';
import 'package:hisab_kitab/data/models/customer_model.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final customerBox = Hive.box<Customer>('customers');

    return ValueListenableBuilder(
      valueListenable: customerBox.listenable(),
      builder: (context, Box<Customer> box, _) {
        if (box.isEmpty) {
          return Center(
            child: Text('No data to display!'.tr(), style: AppTextStyle.body1),
          );
        }

        final customers = box.values.toList();
        final labels = customers.map((c) => c.name).toList();
        final balances = customers.map((c) => c.balance).toList();

        final total = balances.fold<double>(0, (sum, item) => sum + item.abs());
        final totalCredit = balances.where((b) => b >= 0).fold<double>(0, (sum, b) => sum + b);
        final totalDebit = balances.where((b) => b < 0).fold<double>(0, (sum, b) => sum + b.abs());

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(totalCredit, totalDebit),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Total Transactions: '.tr() + ' ₹${total.toStringAsFixed(2)}'.tr(),
                  style: AppTextStyle.body1.copyWith(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildCard(
                title: 'Customer Balance Pie Chart'.tr(),
                child: SizedBox(
                  height: 240,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 40,
                      sections: List.generate(balances.length, (i) {
                        final isPositive = balances[i] >= 0;
                        return PieChartSectionData(
                          color: isPositive
                              ? AppColors.income.withAlpha((0.88 * 255).toInt())
                              : AppColors.expense.withAlpha((0.88 * 255).toInt()),
                          value: balances[i].abs(),
                          title: labels[i].length > 8
                              ? '${labels[i].substring(0, 8)}..'
                              : labels[i],
                          radius: 60,
                          titleStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          titlePositionPercentageOffset: 0.6,
                        );
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '* Red = Debit  |  Green = Credit'.tr(),
                style: AppTextStyle.body2.copyWith(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 20),
              _buildCard(
                title: 'Customer Balances (Bar Chart)'.tr(),
                child: SizedBox(
                  height: 160,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceEvenly,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= labels.length) return const SizedBox();
                              return Text(
                                labels[value.toInt()].length > 6
                                    ? '${labels[value.toInt()].substring(0, 6)}..'
                                    : labels[value.toInt()],
                                style: AppTextStyle.body2.copyWith(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: true),
                      barGroups: List.generate(balances.length, (i) {
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: balances[i].abs(),
                              color: balances[i] >= 0 ? AppColors.income : AppColors.expense,
                              width: 14,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '* Red = Debit  |  Green = Credit'.tr(),
                style: AppTextStyle.body2.copyWith(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(double credit, double debit) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_downward_rounded, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Text("Total to Take".tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "₹${credit.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_upward_rounded, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text("Total to Pay".tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "₹${debit.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyle.heading2),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
