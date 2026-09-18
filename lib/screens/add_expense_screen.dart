import 'package:expense_tracker/widgets/currency_helper.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/textformfield.dart';
import 'package:expense_tracker/models/expense.dart';

final categories = [
  'Food',
  'Travel',
  'Shopping',
  'Bills',
  'Entertainment',
  'Other',
];

class AddExpenseScreen extends StatefulWidget {
  final String selectedCurrency;
  final double exchangeRate;

  const AddExpenseScreen({
    super.key,
    required this.selectedCurrency,
    required this.exchangeRate,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String? selectedCategory;
  DateTime? selectedDate;

  final GlobalKey<FormState> _addexpenseForm = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
        backgroundColor: const Color.fromARGB(221, 150, 124, 124),
      ),
      body: Center(
        child: Form(
          key: _addexpenseForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Textformfield(
                controller: titleController,
                label: 'Expense Title',
                fieldtype: FieldType.text,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter expense title';
                  }
                  return null;
                },
              ),

              Textformfield(
                controller: amountController,
                label: 'Amount (${widget.selectedCurrency})',
                fieldtype: FieldType.decimal,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter valid amount';
                  }
                  return null;
                },
              ),

              Textformfield(
                controller: categoryController,
                label: 'Select category',
                selectedValue: selectedCategory,
                items: categories,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please select category';
                  }
                  return null;
                },
                fieldtype: FieldType.dropdown,
              ),

              Textformfield(
                controller: dateController,
                label: ' Select date',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please select date';
                  }
                  return null;
                },
                fieldtype: FieldType.datetime,
                onTap: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),

              Textformfield(
                controller: noteController,
                label: 'Add a note',
                fieldtype: FieldType.text,
              ),

              ElevatedButton(
                onPressed: () {
                  if (_addexpenseForm.currentState!.validate()) {
                    double enteredAmount = double.parse(amountController.text);
                    double amountInINR;

                    if (widget.selectedCurrency == 'INR') {
                      amountInINR = enteredAmount;
                    } else {
                      amountInINR = CurrencyHelper.convertToINR(
                        amount: enteredAmount,
                        exchangeRate: widget.exchangeRate,
                      );
                    }

                    final expense = Expense(
                      id: DateTime.now().millisecondsSinceEpoch,
                      title: titleController.text,
                      category: selectedCategory!,
                      amount: amountInINR,
                      date: selectedDate!,
                      notes: noteController.text,
                    );

                    Navigator.pop(context, expense);
                  }
                },
                child: Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
