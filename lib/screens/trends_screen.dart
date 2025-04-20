import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'home/widgets/month_navigator.dart';

class TrendsScreen extends StatefulWidget {
  const TrendsScreen({super.key});
  
  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  DateTime _currentMonth = DateTime(2025, 4);
  
  void _handlePreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _handleNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Trends',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: MonthNavigator(
              currentMonth: _currentMonth,
              onPreviousMonth: _handlePreviousMonth,
              onNextMonth: _handleNextMonth,
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.trending_up,
                    size: 64,
                    color: AppColors.primaryBlue.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Expense trends coming soon',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.darkGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}