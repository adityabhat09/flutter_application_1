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
import 'widgets/add_expense_dialog.dart';
import '../../main.dart' as main_data;

// Removed duplicate Expense class definition

// Using the imported Expense class to define dummy data
final List<Expense> dummyExpenses = [
  Expense(id: 'e1', title: 'Groceries', amount: 550.75, date: DateTime(2025, 4, 19), category: 'Food'),
  Expense(id: 'e2', title: 'Electricity Bill', amount: 1200.00, date: DateTime(2025, 4, 15), category: 'Utilities'),
  Expense(id: 'e3', title: 'Movie Tickets', amount: 600.00, date: DateTime(2025, 4, 12), category: 'Entertainment'),
  Expense(id: 'e4', title: 'Dinner Out', amount: 1500.50, date: DateTime(2025, 4, 10), category: 'Food'),
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

 // Access shared expense data 
 List<Expense> get _expenses => main_data.sharedExpenses;

 // Calculate the total spent from the expenses
 double get _totalSpent => _expenses.fold(0.0, (sum, expense) => sum + expense.amount);

 // --- State Management Methods ---

 // Navigate to the previous month
 void _handlePreviousMonth() {
  setState(() {
   _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
  });
 }

 // Navigate to the next month
 void _handleNextMonth() {
  setState(() {
   _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
  });
 }

 // Placeholder for adding a new expense
 Future<void> _handleAddExpense() async {
  final result = await showDialog<Expense>(
   context: context,
   builder: (context) => AddExpenseDialog(selectedDate: _currentMonth),
  );

  if (result != null) {
   setState(() {
    _expenses.add(result);
   });
  }
 }

 Future<void> _handleEditExpense(String id) async {
  final expenseIndex = _expenses.indexWhere((e) => e.id == id);
  if (expenseIndex == -1) return;

  final expense = _expenses[expenseIndex];
  final result = await showDialog<Expense>(
   context: context,
   builder: (context) => AddExpenseDialog(
    selectedDate: expense.date,
    expense: expense,
    isEditing: true,
   ),
  );

  if (result != null) {
   setState(() {
    _expenses[expenseIndex] = result;
   });
  }
 }

 void _handleDeleteExpense(String id) {
  showDialog<bool>(
   context: context,
   builder: (context) => AlertDialog(
    title: const Text('Delete Expense'),
    content: const Text('Are you sure you want to delete this expense?'),
    actions: [
     TextButton(
      onPressed: () => Navigator.pop(context, false),
      child: const Text('Cancel'),
     ),
     TextButton(
      onPressed: () => Navigator.pop(context, true),
      style: TextButton.styleFrom(
       foregroundColor: AppColors.deleteRed,
      ),
      child: const Text('Delete'),
     ),
    ],
   ),
  ).then((confirmed) {
   if (confirmed ?? false) {
    setState(() {
     _expenses.removeWhere((e) => e.id == id);
    });
   }
  });
 }

 void _handleBudgetChanged(double newBudget) {
  setState(() {
   main_data.sharedBudget = newBudget;
  });
 }

 // --- Build Method ---
 @override
 Widget build(BuildContext context) {
  // Use a Scaffold specific to HomeScreen if it needs its own AppBar or FAB
  return Scaffold(
   backgroundColor: Colors.grey[50], // Use theme background color
   appBar: AppBar(
    title: const Text(
     'Expense Tracker',
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
      child: Column(
       children: [
        MonthNavigator(
         currentMonth: _currentMonth,
         onPreviousMonth: _handlePreviousMonth,
         onNextMonth: _handleNextMonth,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BudgetSummaryCard(
           budget: main_data.sharedBudget,
           spent: _totalSpent,
           month: _currentMonth,
           onBudgetChanged: _handleBudgetChanged,
          ),
        ),
       ],
      ),
     ),
     Expanded(
      child: ListView(
       padding: const EdgeInsets.all(16),
       children: [
        Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
          const Text(
           'Expenses',
           style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
           ),
          ),
          ElevatedButton.icon(
           onPressed: _handleAddExpense,
           icon: const Icon(Icons.add, size: 18),
           label: const Text('Add Expense'),
           style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(20),
            ),
           ),
          ),
         ],
        ),
        const SizedBox(height: 16),
        _expenses.isEmpty 
          ? const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 32.0),
                child: Text(
                  'No expenses yet. Add one to get started.',
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          : Column(
              children: _expenses.map((expense) => ExpenseListItem(
                expense: expense,
                onEdit: () => _handleEditExpense(expense.id),
                onDelete: () => _handleDeleteExpense(expense.id),
              )).toList(),
            ),
       ],
      ),
     ),
    ],
   ),
  );
 }
}