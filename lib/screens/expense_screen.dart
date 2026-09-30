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
      //backgroundColor: Colors.transparent,
      isScrollControlled: true,

      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFF9F7FF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),

            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 2,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  SizedBox(height: 15),

                  Text(
                    'Filter by Category',
                    style: TextStyle(
                      color: Color(0xFF173B63),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  ...categories.map((category) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: RadioGroup(
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
                            Material(
                              color: Colors.transparent,
                              child: RadioListTile<String>(
                                title: Row(
                                  children: [
                                    Container(
                                      height: 36,
                                      width: 36,

                                      decoration: const BoxDecoration(
                                        color: Color(0xFFD9F1F0),
                                        shape: BoxShape.circle,
                                      ),

                                      child: Icon(
                                        getCategoryIcon(category),
                                        color: const Color(0xFF258C88),
                                        size: 19,
                                      ),
                                    ),

                                    const SizedBox(width: 12),
                                    Text(
                                      category,
                                      style: const TextStyle(
                                        color: Color(0xFF263B53),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                value: category,
                                activeColor: Color(0xFF7562D9),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
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
      backgroundColor: Color.fromARGB(255, 232, 242, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 232, 242, 255),
        foregroundColor: Color(0xFF172B4D),
        title: Text(
          'Expense List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
          ? SafeArea(
              child: Center(
                child: Text(
                  selectedFilter == 'All'
                      ? 'No Expense added..'
                      : 'No $selectedFilter expenses found.',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: StretchingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  child: ListView.builder(
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
                ),
              ),
            ),
    );
  }
}
