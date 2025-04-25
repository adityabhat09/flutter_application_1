import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../models/expense.dart';
import 'home/widgets/month_navigator.dart';
import 'dart:math' as math;
import '../main.dart' as main_data;

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});
  
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  DateTime _currentMonth = DateTime(2025, 4);
  
  // Get expenses filtered by the selected month
  List<Expense> get _expenses => main_data.getExpensesForMonth(_currentMonth);
  
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
  
  double get _totalSpent => _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  
  double get _averagePerTransaction => _expenses.isEmpty ? 0.0 : _totalSpent / _expenses.length;
  
  Map<String, double> get _spendingByCategory {
    final categories = <String, double>{};
    for (final expense in _expenses) {
      categories[expense.category] = (categories[expense.category] ?? 0) + expense.amount;
    }
    return categories;
  }
  
  Map<String, Color> get _categoryColors => {
    'Transport': AppColors.primaryBlue,
    'Food': Colors.orange,
    'Entertainment': Colors.purple,
    'Shopping': Colors.red,
    'Utilities': Colors.teal,
    'Other': Colors.amber,
  };
  
  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: 'Rs');
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Analytics',
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
          // Month Navigation
          Container(
            color: Colors.white,
            child: MonthNavigator(
              currentMonth: _currentMonth,
              onPreviousMonth: _handlePreviousMonth,
              onNextMonth: _handleNextMonth,
            ),
          ),
          
          // Summary Cards
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Total Expenses Card
                Expanded(
                  child: _SummaryCard(
                    title: 'Total Expenses',
                    value: currencyFormat.format(_totalSpent),
                  ),
                ),
                const SizedBox(width: 16),
                // Average per Transaction Card
                Expanded(
                  child: _SummaryCard(
                    title: 'Avg. per Transaction',
                    value: currencyFormat.format(_averagePerTransaction),
                  ),
                ),
              ],
            ),
          ),
          
          // Spending by Category
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Spending by Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _spendingByCategory.isEmpty
                          ? const Center(child: Text('No expenses for this month'))
                          : Row(
                              children: [
                                // Pie Chart
                                Expanded(
                                  flex: 3,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CustomPaint(
                                        size: const Size(double.infinity, double.infinity),
                                        painter: _PieChartPainter(
                                          categories: _spendingByCategory,
                                          totalAmount: _totalSpent,
                                          colorMap: _categoryColors,
                                        ),
                                      ),
                                      // Percentage for the largest category
                                      if (_spendingByCategory.isNotEmpty)
                                        Builder(
                                          builder: (context) {
                                            // Find category with highest spending
                                            final largestCategory = _spendingByCategory.entries
                                                .reduce((a, b) => a.value > b.value ? a : b);
                                            final percentage = ((largestCategory.value / _totalSpent) * 100).toStringAsFixed(0);
                                            
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "$percentage%",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    shadows: [
                                                      Shadow(
                                                        offset: Offset(0, 1),
                                                        blurRadius: 3.0,
                                                        color: Color.fromARGB(80, 0, 0, 0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 20,
                                                  height: 1,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            );
                                          }
                                        ),
                                    ],
                                  ),
                                ),
                                
                                // Legend
                                if (_spendingByCategory.length > 1)
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: _spendingByCategory.entries.map((entry) {
                                          final percentage = ((entry.value / _totalSpent) * 100).toStringAsFixed(0);
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 16,
                                                  height: 16,
                                                  color: _categoryColors[entry.key] ?? Colors.grey,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    '${entry.key} $percentage%',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                      ),
                      
                      // If only one category, show it below the chart
                      if (_spendingByCategory.length == 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                color: _categoryColors[_spendingByCategory.keys.first] ?? Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _spendingByCategory.keys.first,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  
  const _SummaryCard({
    required this.title,
    required this.value,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.darkGrey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final Map<String, double> categories;
  final double totalAmount;
  final Map<String, Color> colorMap;
  
  _PieChartPainter({
    required this.categories,
    required this.totalAmount,
    required this.colorMap,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2.5;
    
    var startAngle = -math.pi / 2; // Start from the top
    
    final paint = Paint()
      ..style = PaintingStyle.fill;
    
    categories.forEach((category, amount) {
      final sweepAngle = (amount / totalAmount) * 2 * math.pi;
      
      paint.color = colorMap[category] ?? Colors.grey;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      
      startAngle += sweepAngle;
    });
  }
  
  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return oldDelegate.categories != categories || 
           oldDelegate.totalAmount != totalAmount ||
           oldDelegate.colorMap != colorMap;
  }
}