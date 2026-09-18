import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/screens/add_expense_screen.dart';
import 'package:expense_tracker/widgets/currency_helper.dart';
import 'package:expense_tracker/widgets/expense_card.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  final List<Expense> expenses;
  final String selectedCurrency;
  final double exchangeRate;

  const StatisticsScreen({
    super.key,
    required this.expenses,
    required this.selectedCurrency,
    required this.exchangeRate,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;

    // recent rxpense
    List<Expense> recentExpenses = [...expenses];

    recentExpenses.sort((a, b) {
      final dateCompare = b.date.compareTo(a.date);

      if (dateCompare != 0) {
        return dateCompare;
      }
      return b.id.compareTo(a.id);
    });

    recentExpenses = recentExpenses.take(5).toList();

    //category summery
    final categoryTotals = {
      for (final category in categories)
        category: expenses
            .where((expense) => expense.category == category)
            .fold(0.0, (sum, expense) => sum + expense.amount),
    };

    final maxCategoryTotal = categoryTotals.values.isEmpty
        ? 0.0
        : categoryTotals.values.reduce((a, b) => a > b ? a : b);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Statistics'),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Category'),
              Tab(text: 'Recent'),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            //Text('this is category'),
            Card(
              margin: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final total = categoryTotals[category] ?? 0.0;
                  final progress = maxCategoryTotal == 0
                      ? 0.0
                      : total / maxCategoryTotal;

                  return Container(
                    margin: EdgeInsets.only(
                      left: width * 0.025,
                      right: width * 0.025,
                      top: 8,
                      bottom: 8,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '${CurrencyHelper.convert(amount: total, exchangeRate: exchangeRate).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            expenses.isEmpty
                ? Center(
                    child: Text(
                      'No recent expenses',
                      style: TextStyle(fontSize: 15),
                    ),
                  )
                : ListView.builder(
                    itemCount: recentExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = recentExpenses[index];
                      return ExpenseCard(
                        expense: expense,
                        selectedCurrency: selectedCurrency,
                        exchangeRate: exchangeRate,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
