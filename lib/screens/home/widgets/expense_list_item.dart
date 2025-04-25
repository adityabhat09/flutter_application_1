import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/expense.dart';
import '../../../constants/app_colors.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  
  const ExpenseListItem({
    super.key, 
    required this.expense,
    this.onEdit,
    this.onDelete,
  });
  
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Transport':
        return AppColors.transportBlue;
      case 'Food':
        return Colors.orange;
      case 'Entertainment':
        return Colors.purple;
      case 'Utilities':
        return Colors.teal;
      default:
        return Colors.amber; // For 'Other' or unknown categories
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final categoryColor = _getCategoryColor(expense.category);
    
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: categoryColor,
            width: 4,
          ),
        ),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  expense.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Rs${expense.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      dateFormat.format(expense.date),
                      style: const TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: categoryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        expense.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Edit'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.darkGrey,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline, size: 16),
                      label: const Text('Delete'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.deleteRed,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}