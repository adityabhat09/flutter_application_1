import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For currency formatting
import '../../../constants/app_colors.dart'; // Assuming you have app_colors.dart
import 'edit_budget_dialog.dart';

class BudgetSummaryCard extends StatelessWidget {
  final double budget;
  final double spent;
  final DateTime month; // To display "Budget for April 2025"
  final Function(double) onBudgetChanged;

  const BudgetSummaryCard({
    super.key,
    required this.budget,
    required this.spent,
    required this.month,
    required this.onBudgetChanged,
  });

  Future<void> _handleEditBudget(BuildContext context) async {
    final result = await showDialog<double>(
      context: context,
      builder: (context) => EditBudgetDialog(
        currentBudget: budget,
        month: month,
      ),
    );

    if (result != null) {
      onBudgetChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (budget > 0) ? (spent / budget).clamp(0.0, 1.0) : 0.0;
    final double remaining = budget - spent;
    final bool isBudgetExceeded = spent > budget;
    final percentSpent = (progress * 100).toStringAsFixed(1);
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$'); // Adjust locale/symbol as needed

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Budget for ${DateFormat('MMMM yyyy').format(month)}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () => _handleEditBudget(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Budget',
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormat.format(budget),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Spent',
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormat.format(spent),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isBudgetExceeded ? AppColors.deleteRed : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isBudgetExceeded ? 'Budget Exceeded' : 'Within Budget',
                  style: TextStyle(
                    color: isBudgetExceeded ? AppColors.deleteRed : AppColors.progressGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$percentSpent%',
                  style: TextStyle(
                    color: isBudgetExceeded ? AppColors.deleteRed : AppColors.darkGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.lightGrey,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isBudgetExceeded ? AppColors.deleteRed : AppColors.progressGreen
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isBudgetExceeded 
                ? '${currencyFormat.format(remaining.abs())} over budget' 
                : '${currencyFormat.format(remaining)} left to spend',
              style: TextStyle(
                color: isBudgetExceeded ? AppColors.deleteRed : AppColors.darkGrey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}