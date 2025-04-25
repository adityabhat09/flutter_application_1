import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class EditBudgetDialog extends StatefulWidget {
  final double currentBudget;
  final DateTime month;

  const EditBudgetDialog({
    super.key,
    required this.currentBudget,
    required this.month,
  });

  @override
  State<EditBudgetDialog> createState() => _EditBudgetDialogState();
}

class _EditBudgetDialogState extends State<EditBudgetDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    _budgetController = TextEditingController(text: widget.currentBudget.toString());
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
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
              const Text(
                'Edit Budget',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _budgetController,
                decoration: const InputDecoration(
                  labelText: 'Monthly Budget',
                  border: OutlineInputBorder(),
                  prefixText: 'Rs ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a budget amount';
                  }
                  final budget = double.tryParse(value);
                  if (budget == null) {
                    return 'Please enter a valid number';
                  }
                  if (budget <= 0) {
                    return 'Budget must be greater than zero';
                  }
                  return null;
                },
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
                        final newBudget = double.parse(_budgetController.text);
                        Navigator.pop(context, newBudget);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save'),
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