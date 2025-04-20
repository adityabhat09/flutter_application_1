import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../models/expense.dart';

class AddExpenseDialog extends StatefulWidget {
  final DateTime selectedDate;
  final Expense? expense; // Optional expense for editing
  final bool isEditing;

  const AddExpenseDialog({
    super.key,
    required this.selectedDate,
    this.expense,
    this.isEditing = false,
  });

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late DateTime _selectedDate;
  late String _selectedCategory;

  final List<String> _categories = ['Transport', 'Food', 'Entertainment', 'Utilities', 'Other'];

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing data if editing
    if (widget.expense != null) {
      _titleController = TextEditingController(text: widget.expense!.title);
      _amountController = TextEditingController(text: widget.expense!.amount.toString());
      _selectedDate = widget.expense!.date;
      _selectedCategory = widget.expense!.category;
    } else {
      _titleController = TextEditingController();
      _amountController = TextEditingController();
      _selectedDate = widget.selectedDate;
      _selectedCategory = 'Transport';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isEditing ? 'Edit Expense' : 'Add Expense',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
                      const Icon(Icons.calendar_today, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final expense = Expense(
                          id: widget.expense?.id ?? DateTime.now().toString(),
                          title: _titleController.text,
                          amount: double.parse(_amountController.text),
                          date: _selectedDate,
                          category: _selectedCategory,
                        );
                        Navigator.pop(context, expense);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(widget.isEditing ? 'Save' : 'Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 