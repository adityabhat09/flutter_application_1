// main.dart (Remains unchanged from previous version)
import 'package:flutter/material.dart';
// Assuming these imports exist and point to the correct file locations
import 'screens/home/home_screen.dart'; // Assuming this exists
import 'screens/analytics_screen.dart';
import 'screens/trends_screen.dart';
import 'screens/settings_screen.dart';
import 'models/expense.dart';
// Assuming this exists and defines the colors used
// import 'constants/app_colors.dart';

// Placeholder for AppColors if the import is missing or for demonstration
class AppColors {
 static const Color primaryBlue = Colors.blue;
 static const Color textBlack = Colors.black;
 static const Color darkGrey = Colors.grey;
 // Add any other colors used in HomeScreen if needed
 // static const Color backgroundGrey = Color(0xFFF5F5F5); // Example
}

// Shared expense data
final List<Expense> sharedExpenses = [
  // April 2025 expenses - total $66
  Expense(
    id: '1',
    title: 'breakfast',
    amount: 20.00,
    date: DateTime(2025, 4, 18),
    category: 'Transport',
  ),
  Expense(
    id: '2',
    title: 'shoes',
    amount: 34.00,
    date: DateTime(2025, 4, 18),
    category: 'Transport',
  ),
  Expense(
    id: '3',
    title: 'breakfast',
    amount: 12.00,
    date: DateTime(2025, 4, 18),
    category: 'Transport',
  ),
  
  // February 2025 expenses - total $0 (empty)
  
  // December 2024 expenses - total $234
  Expense(
    id: '4',
    title: 'Holiday Gifts',
    amount: 150.00,
    date: DateTime(2024, 12, 20),
    category: 'Shopping',
  ),
  Expense(
    id: '5',
    title: 'Christmas Dinner',
    amount: 84.00,
    date: DateTime(2024, 12, 25),
    category: 'Food',
  ),
];

double sharedBudget = 200.00;

// Function to get expenses for a specific month
List<Expense> getExpensesForMonth(DateTime month) {
  return sharedExpenses.where((expense) {
    return expense.date.year == month.year && expense.date.month == month.month;
  }).toList();
}

// Function to get total spending by month for the last 6 months
Map<DateTime, double> getMonthlySpending() {
  final now = DateTime(2025, 4); // Using April 2025 as the current month for this example
  final result = <DateTime, double>{};
  
  // Get data for the last 6 months
  for (int i = 0; i < 6; i++) {
    final month = DateTime(now.year, now.month - i);
    final expenses = getExpensesForMonth(month);
    final total = expenses.fold(0.0, (sum, expense) => sum + expense.amount);
    result[month] = total;
  }
  
  return result;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ super . key });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title : 'Expense Tracker',
      theme : ThemeData(
        primarySwatch : Colors.blue, // Base color
        primaryColor : AppColors.primaryBlue,
        scaffoldBackgroundColor : Colors.grey[50], // Light background
        fontFamily : 'Inter', // Example: Use a custom font if desired
        appBarTheme : const AppBarTheme(
          backgroundColor : Colors.white, // Or your preferred AppBar color
          elevation : 0, // Flat AppBar
          foregroundColor : AppColors.textBlack, // Title color
          iconTheme : IconThemeData( color : AppColors.textBlack), // Icon color
          titleTextStyle : TextStyle(
            color : AppColors.textBlack,
            fontSize : 20.0,
            fontWeight : FontWeight.bold,
          ),
        ),
         visualDensity : VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner : false,
      home : const MainAppShell(), // Use a shell for bottom navigation
    );
  }
}

// This widget holds the BottomNavigationBar and manages the currently displayed screen
class MainAppShell extends StatefulWidget {
  const MainAppShell({ super . key });

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _selectedIndex = 0; // Index for the selected tab

  // List of widgets to display for each tab
  // Note: HomeScreen() cannot be const because it's a StatefulWidget
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(), // Use const here as HomeScreen now has a const constructor
    const AnalyticsScreen(), // These screens can be const
    const TrendsScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar is now handled within HomeScreen, so remove conditional AppBar here
      // appBar : _selectedIndex == 0 ? AppBar( ... ) : null,
      body : Center(
        child : _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar : BottomNavigationBar(
        items : const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon : Icon(Icons.home_outlined),
            activeIcon : Icon(Icons.home), // Optional: different icon when active
            label : 'Home',
          ),
          BottomNavigationBarItem(
            icon : Icon(Icons.analytics_outlined),
             activeIcon : Icon(Icons.analytics),
            label : 'Analytics',
          ),
          BottomNavigationBarItem(
            icon : Icon(Icons.trending_up_outlined),
             activeIcon : Icon(Icons.trending_up),
            label : 'Trends',
          ),
          BottomNavigationBarItem(
            icon : Icon(Icons.settings_outlined),
            activeIcon : Icon(Icons.settings),
            label : 'Settings',
          ),
        ],
        currentIndex : _selectedIndex,
        selectedItemColor : AppColors.primaryBlue, // Color for selected item
        unselectedItemColor : AppColors.darkGrey, // Color for unselected items
        onTap : _onItemTapped,
        type : BottomNavigationBarType.fixed, // Ensures all labels are visible
        backgroundColor : Colors.white, // Background color of the nav bar
        elevation : 5.0, // Add shadow to the nav bar
        showUnselectedLabels : true, // Show labels for unselected items too
        selectedFontSize : 12.0, // Adjust font size
        unselectedFontSize : 12.0,
      ),
    );
  }
}