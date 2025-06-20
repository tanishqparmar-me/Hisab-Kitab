import 'package:flutter/material.dart';
import 'package:hisab_kitab/constants/app_colors.dart';
import 'package:hisab_kitab/constants/app_text_style.dart';
import 'package:hisab_kitab/data/models/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type.toLowerCase() == 'credit';
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(transaction.date);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withAlpha((0.1 * 255).toInt()),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: isCredit
                  ? AppColors.income.withAlpha((0.1 * 255).toInt())
                  : AppColors.expense.withAlpha((0.1 * 255).toInt()),
              child: Icon(
                isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                color: isCredit ? AppColors.income : AppColors.expense,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.note.isNotEmpty ? transaction.note : (isCredit ? 'Received' : 'Sent'),
                    style: AppTextStyle.body1.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: AppTextStyle.body2.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Text(
              '₹${transaction.amount.toStringAsFixed(2)}',
              style: isCredit
                  ? AppTextStyle.balancePositive
                  : AppTextStyle.balanceNegative,
            ),
          ],
        ),
      ),
    );
  }
}
