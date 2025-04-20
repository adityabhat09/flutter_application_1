import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import 'home/widgets/month_navigator.dart';
import '../main.dart' as main_data;

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
    final monthlySpending = main_data.getMonthlySpending();
    final maxAmount = monthlySpending.values.isEmpty 
        ? 100.0 
        : monthlySpending.values.reduce((a, b) => a > b ? a : b);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Spending Trends',
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Monthly Spending Trends',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 260,
                            child: _BarChart(
                              data: monthlySpending,
                              maxAmount: maxAmount,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Legend
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                color: AppColors.primaryBlue,
                              ),
                              const SizedBox(width: 8),
                              const Text('Total'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'This chart shows your spending trends over the past 6 months.',
                    style: TextStyle(
                      color: AppColors.darkGrey,
                      fontSize: 14,
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

class _BarChart extends StatelessWidget {
  final Map<DateTime, double> data;
  final double maxAmount;
  
  const _BarChart({
    required this.data,
    required this.maxAmount,
  });
  
  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    final dateFormat = DateFormat('MMMM');
    
    // Calculate step size for y-axis
    final yAxisMax = ((maxAmount ~/ 60) + 1) * 60.0;
    final step = yAxisMax / 4; // 4 steps on the y-axis
    
    // Sort data by date
    final sortedData = data.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    
    // Take the last 3 months to display
    final displayData = sortedData.length > 3 
        ? sortedData.sublist(sortedData.length - 3) 
        : sortedData;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = constraints.maxWidth;
        final chartHeight = constraints.maxHeight - 50; // Reserve space for x-axis labels
        
        return Column(
          children: [
            // Y-axis labels and chart
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Y-axis labels
                SizedBox(
                  width: 60,
                  height: chartHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        currencyFormat.format(yAxisMax),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        currencyFormat.format(yAxisMax - step),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        currencyFormat.format(yAxisMax - 2 * step),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        currencyFormat.format(yAxisMax - 3 * step),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      const Text(
                        '\$0',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Chart
                Expanded(
                  child: SizedBox(
                    height: chartHeight,
                    child: CustomPaint(
                      painter: _BarChartPainter(
                        data: displayData,
                        maxAmount: yAxisMax,
                      ),
                      size: Size(chartWidth, chartHeight),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // X-axis labels
            Row(
              children: [
                const SizedBox(width: 70), // Space for y-axis labels
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: displayData.map((entry) {
                      return Text(
                        dateFormat.format(entry.key),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGrey,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<MapEntry<DateTime, double>> data;
  final double maxAmount;
  
  _BarChartPainter({
    required this.data,
    required this.maxAmount,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final barWidth = width / (data.length * 2); // Bar width with spacing
    
    // Draw horizontal grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    for (int i = 0; i <= 4; i++) {
      final y = height - (height * i / 4);
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }
    
    // Draw bars
    final barPaint = Paint()
      ..color = AppColors.primaryBlue
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < data.length; i++) {
      final value = data[i].value;
      final barHeight = (value / maxAmount) * height;
      
      final left = (width / data.length) * i + (width / data.length - barWidth) / 2;
      final top = height - barHeight;
      final right = left + barWidth;
      final bottom = height;
      
      final rect = Rect.fromLTRB(left, top, right, bottom);
      canvas.drawRect(rect, barPaint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}