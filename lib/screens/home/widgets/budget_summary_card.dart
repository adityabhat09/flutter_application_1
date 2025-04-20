import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For currency formatting
import '../../../constants/app_colors.dart'; // Assuming you have app_colors.dart

class BudgetSummaryCard extends StatelessWidget {
  final double budget;
  final double spent;
  final DateTime month; // To display "Budget for April 2025"

  const BudgetSummaryCard({
    super.key,
    required this.budget,
    required this.spent,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (budget > 0) ? (spent / budget).clamp(0.0, 1.0) : 0.0;
    final double remaining = budget - spent;
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$'); // Adjust locale/symbol as needed
    final monthFormat = DateFormat('MMMM yyyy'); // Format month and year

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                   'Budget for ${monthFormat.format(month)}',
                   style: const TextStyle(
                     fontWeight: FontWeight.bold,
                     fontSize: 16.0,
                     color: AppColors.textBlack,
                   ),
                 ),
                InkWell(
                   onTap: () {
                     // Handle Edit Budget action
                     print("Edit Budget Tapped");
                   },
                   child: const Icon(Icons.edit_outlined, size: 20.0, color: AppColors.darkGrey),
                 ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Budget and Spent Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Budget', style: TextStyle(color: AppColors.darkGrey, fontSize: 13)),
                      const SizedBox(height: 4.0),
                      Text(
                        currencyFormat.format(budget),
                        style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0), // Spacing between budget and spent
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Spent', style: TextStyle(color: AppColors.darkGrey, fontSize: 13)),
                       const SizedBox(height: 4.0),
                      Text(
                         currencyFormat.format(spent),
                         style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Progress Bar and Labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Within Budget', style: TextStyle(color: AppColors.budgetGreen, fontWeight: FontWeight.w500)),
                 Text('${(progress * 100).toStringAsFixed(1)}%', style: const TextStyle(color: AppColors.darkGrey, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 8.0),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.lightGrey,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue), // Use primary blue for progress
              minHeight: 6.0, // Adjust thickness
              borderRadius: BorderRadius.circular(3.0), // Rounded corners
            ),
            const SizedBox(height: 8.0),

            // Remaining Amount
            Text(
              '${currencyFormat.format(remaining)} left to spend',
              style: const TextStyle(color: AppColors.darkGrey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}