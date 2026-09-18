import 'package:expense_tracker/screens/expense_details_screen.dart';
import 'package:expense_tracker/widgets/expense_card.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class ExpenseScreen extends StatefulWidget {
  final List<Expense> expenses;
  final Function(int) onDelete;
  final Function(Expense) onUpdate;
  final String selectedCurrency;
  final double exchangeRate;

  const ExpenseScreen({
    super.key,
    required this.expenses,
    required this.onDelete,
    required this.onUpdate,
    required this.selectedCurrency,
    required this.exchangeRate,
  });

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  String selectedFilter = 'All';

  final List<String> categories = [
    'All',
    'Food',
    'Travel',
    'Shopping',
    'Bills',
    'Entertainment',
    'Other',
  ];

  void showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Filter by Category'),
              ...categories.map((category) {
                return RadioGroup(
                  groupValue: selectedFilter,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedFilter = value;
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        title: Text(category),
                        value: category,
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredExpenses = selectedFilter == 'All'
        ? widget.expenses
        : widget.expenses
              .where((expense) => expense.category == selectedFilter)
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense List'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: showFilterBottomSheet,
              child: Row(children: [Icon(Icons.filter_alt), Text('Filter')]),
            ),
          ),
        ],
      ),
      body: filteredExpenses.isEmpty
          ? Center(
              child: Text(
                selectedFilter == 'All'
                    ? 'No Expense added..'
                    : 'No $selectedFilter expenses found.',
                style: const TextStyle(fontSize: 15),
              ),
            )
          : ListView.builder(
              itemCount: filteredExpenses.length,
              itemBuilder: (context, index) {
                final expense = filteredExpenses[index];

                return InkWell(
                  onTap: () async {
                    final updatedExpense = await Navigator.push<Expense>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExpenseDetailsScreen(
                          expense: expense,
                          onDelete: () {
                            widget.onDelete(expense.id);
                          },
                          onUpdate: widget.onUpdate,
                          selectedCurrency: widget.selectedCurrency,
                          exchangeRate: widget.exchangeRate,
                        ),
                      ),
                    );
                    if (updatedExpense != null) {
                      widget.onUpdate(updatedExpense);
                    }
                  },
                  child: ExpenseCard(
                    expense: expense,
                    selectedCurrency: widget.selectedCurrency,
                    exchangeRate: widget.exchangeRate,
                  ),
                );
              },
            ),
    );
  }
}
