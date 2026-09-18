import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/currency_helper.dart';
import 'package:expense_tracker/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/screens/add_expense_screen.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;
  final String selectedCurrency;
  final double exchangeRate;

  const EditExpenseScreen({
    super.key,
    required this.expense,
    required this.selectedCurrency,
    required this.exchangeRate,
  });

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreen();
}

class _EditExpenseScreen extends State<EditExpenseScreen> {
  late TextEditingController titleController;
  late TextEditingController amountController;
  late TextEditingController notesController;
  late TextEditingController dateController;
  late String selectedCategory;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.expense.title);
    double displayAmount;

    if (widget.selectedCurrency == 'INR') {
      displayAmount = widget.expense.amount;
    } else {
      displayAmount = CurrencyHelper.convert(
        amount: widget.expense.amount,
        exchangeRate: widget.exchangeRate,
      );
    }
    amountController = TextEditingController(
      text: displayAmount.toStringAsFixed(2),
    );
    notesController = TextEditingController(text: widget.expense.notes ?? '');
    selectedCategory = widget.expense.category;
    selectedDate = widget.expense.date;
    dateController = TextEditingController(
      text: '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    notesController.dispose();
    dateController.dispose();

    super.dispose();
  }

  void saveChanges() {
    final enteredAmount = double.parse(amountController.text);
    double amountInINR;
    if (widget.selectedCurrency == 'INR') {
      amountInINR = enteredAmount;
    } else {
      amountInINR = CurrencyHelper.convertToINR(
        amount: enteredAmount,
        exchangeRate: widget.exchangeRate,
      );
    }
    final updatedExpense = Expense(
      id: widget.expense.id,
      title: titleController.text,
      amount: amountInINR,
      category: selectedCategory,
      date: selectedDate,
      notes: notesController.text,
    );
    Navigator.pop(context, updatedExpense);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Expense updated successfully!!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Expense')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Textformfield(
              controller: titleController,
              label: 'Title',
              fieldtype: FieldType.text,
            ),
            Textformfield(
              controller: amountController,
              label: 'Amount',
              fieldtype: FieldType.decimal,
            ),
            Textformfield(
              label: ' Select category',
              fieldtype: FieldType.dropdown,
              items: categories,
              selectedValue: selectedCategory,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
            ),
            Textformfield(
              controller: dateController,
              label: 'Select Date',
              fieldtype: FieldType.datetime,
              selectedDate: selectedDate,
              onTap: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            Textformfield(
              controller: notesController,
              label: 'Note',
              fieldtype: FieldType.text,
            ),
            ElevatedButton(onPressed: saveChanges, child: Text('Save Changes')),
          ],
        ),
      ),
    );
  }
}
