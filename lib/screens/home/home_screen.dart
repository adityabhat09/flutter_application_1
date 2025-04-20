// screens/home/home_screen.dart (Updated)
// =============================================
// Note: Ensure the imported files (models/expense.dart, constants/app_colors.dart,
// widgets/month_navigator.dart, widgets/budget_summary_card.dart,
// widgets/expense_list_item.dart) exist and contain the necessary definitions.
import 'package:flutter/material.dart';
import '../../models/expense.dart';
import '../../constants/app_colors.dart';
import 'widgets/month_navigator.dart';
import 'widgets/budget_summary_card.dart';
import 'widgets/expense_list_item.dart';

// Removed duplicate Expense class definition

// Using the imported Expense class to define dummy data
final List<Expense> dummyExpenses = [
  Expense(id: 'e1', title: 'Groceries', amount: 550.75, date: DateTime(2025, 4, 19), category: 'Food', icon: Icons.shopping_cart),
  Expense(id: 'e2', title: 'Electricity Bill', amount: 1200.00, date: DateTime(2025, 4, 15), category: 'Utilities', icon: Icons.lightbulb),
  Expense(id: 'e3', title: 'Movie Tickets', amount: 600.00, date: DateTime(2025, 4, 12), category: 'Entertainment', icon: Icons.movie),
  Expense(id: 'e4', title: 'Dinner Out', amount: 1500.50, date: DateTime(2025, 4, 10), category: 'Food', icon: Icons.restaurant),
];
const double dummyBudget = 25000.00;
const double dummySpent = 3851.25; // Sum of dummyExpenses


class HomeScreen extends StatefulWidget {
  // Add const constructor
 const HomeScreen({super.key});

 @override
 State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 // State to manage the currently displayed month
 // Initialize with the current date or a default like April 2025 from the image
 DateTime _currentMonth = DateTime(2025, 4); // April 2025

 // In a real app, you'd fetch expenses based on _currentMonth
 // For now, using dummy data defined above
 List<Expense> _monthlyExpenses = dummyExpenses;
 double _budget = dummyBudget;
 double _spent = dummySpent;

 // --- State Management Methods ---

 // Navigate to the previous month
 void _goToPreviousMonth() {
  setState(() {
   _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
   // TODO: Fetch or filter expenses for the new _currentMonth
   // Example: _loadDataForMonth(_currentMonth);
   print("Navigating to previous month: $_currentMonth"); // Placeholder action
  });
 }

 // Navigate to the next month
 void _goToNextMonth() {
  setState(() {
   _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
   // TODO: Fetch or filter expenses for the new _currentMonth
   // Example: _loadDataForMonth(_currentMonth);
   print("Navigating to next month: $_currentMonth"); // Placeholder action
  });
 }

 // Placeholder for adding a new expense
 void _addExpense() {
  // TODO: Implement navigation or show dialog to add an expense
  print("Add Expense Tapped");
  // Show a temporary snackbar message
  ScaffoldMessenger.of(context).showSnackBar(
   const SnackBar(content: Text('Navigate to Add Expense Screen (Not Implemented)')),
  );
 }

 // --- Build Method ---
 @override
 Widget build(BuildContext context) {
  // Use a Scaffold specific to HomeScreen if it needs its own AppBar or FAB
  return Scaffold(
   backgroundColor: Colors.grey[50], // Use theme background color
   body: CustomScrollView( // Use CustomScrollView for mixed sliver/non-sliver content
    slivers: [
     // --- Non-Scrolling Header Section ---
     SliverToBoxAdapter(
      child: Container( // Wrap in a container for background color if needed
        color: Colors.white, // Example background for the top section
        padding: const EdgeInsets.only(bottom: 10.0), // Padding below the card
        child: Column(
         children: [
          // Month Navigation Widget
          MonthNavigator(
           currentMonth: _currentMonth,
           onPreviousMonth: _goToPreviousMonth,
           onNextMonth: _goToNextMonth,
          ),
          // Budget Summary Card Widget
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add horizontal padding
            child: BudgetSummaryCard(
             budget: _budget, // Use dummy data
             spent: _spent,   // Use dummy data
             month: _currentMonth,
            ),
          ),
          // const SizedBox(height: 20), // Spacing moved below
         ],
        ),
      ),
     ),

     // --- Expenses Section Header ---
     SliverPadding(
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 10.0), // Adjust padding
      sliver: SliverToBoxAdapter(
       child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         // "Expenses" Title
         const Text(
          'Expenses',
          style: TextStyle(
           fontSize: 18.0,
           fontWeight: FontWeight.bold,
           color: AppColors.textBlack, // Use color from constants
          ),
         ),
         // "Add Expense" Button
         ElevatedButton.icon(
          onPressed: _addExpense,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Expense'),
          style: ElevatedButton.styleFrom(
           backgroundColor: AppColors.primaryBlue, // Use color from constants
           foregroundColor: Colors.white,
           shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded button
           ),
           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
           elevation: 2, // Add slight elevation
          ),
         ),
        ],
       ),
      ),
     ),

     // --- Scrolling Expense List ---
     SliverPadding(
      // Add padding around the list, especially at the bottom
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      sliver: SliverList(
       // Use a delegate to build list items efficiently
       delegate: SliverChildBuilderDelegate(
        (context, index) {
         // Get the specific expense for this index
         final expense = _monthlyExpenses[index];
         // Return the custom list item widget
         // Add padding/margin around each item if needed within ExpenseListItem or here
         return Padding(
           padding: const EdgeInsets.only(bottom: 8.0), // Space between items
           child: ExpenseListItem(expense: expense),
         );
        },
        // Set the total number of items in the list
        childCount: _monthlyExpenses.length,
       ),
      ),
     ),
    ],
   ),
  );
 }
}