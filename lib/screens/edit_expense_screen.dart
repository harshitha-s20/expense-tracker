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
    double height = MediaQuery.of(context).size.height;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;

    final double boxHeight = isPortrait ? height * 0.06 : 20;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 232, 242, 255),
      appBar: AppBar(
        backgroundColor: Color(0xFF234E70),
        foregroundColor: Colors.white,
        title: Text('Edit Expense'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Textformfield(
                  controller: titleController,
                  label: 'Title',
                  fieldtype: FieldType.text,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter expense title';
                    }
                    return null;
                  },
                ),

                SizedBox(height: boxHeight),

                Textformfield(
                  controller: amountController,
                  label: 'Amount',
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

                SizedBox(height: boxHeight),

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
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please select category';
                    }
                    return null;
                  },
                ),

                SizedBox(height: boxHeight),

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
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please select date';
                    }
                    return null;
                  },
                ),

                SizedBox(height: boxHeight),

                Textformfield(
                  controller: notesController,
                  label: 'Note',
                  fieldtype: FieldType.text,
                ),

                SizedBox(height: boxHeight),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7567D9),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: saveChanges,
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
