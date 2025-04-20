import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package

class MonthNavigator extends StatelessWidget {
  final DateTime currentMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const MonthNavigator({
    super.key,
    required this.currentMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    // Format the date like "April 2025"
    final String formattedMonth = DateFormat('MMMM yyyy').format(currentMonth);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPreviousMonth,
            iconSize: 28,
          ),
          Text(
            formattedMonth,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNextMonth,
            iconSize: 28,
          ),
        ],
      ),
    );
  }
}