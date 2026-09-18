import 'package:expense_tracker/screens/add_expense_screen.dart';
import 'package:expense_tracker/widgets/currency_helper.dart';
import 'package:expense_tracker/widgets/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class Dashboard extends StatelessWidget {
  final List<Expense> expenses;
  final String selectedCurrency;
  final double exchangeRate;

  const Dashboard({
    super.key,
    required this.expenses,
    required this.selectedCurrency,
    required this.exchangeRate,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    //Total Expense
    final double totalExpense = expenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );

    //Highest Expense
    final double highestExpense = expenses.isEmpty
        ? 0.0
        : expenses
              .map((expense) => expense.amount)
              .reduce((a, b) => a > b ? a : b);

    //Current month's Expense
    final now = DateTime.now();
    final double currentMonthsExpense = expenses
        .where(
          (expenses) =>
              expenses.date.month == now.month &&
              expenses.date.year == now.year,
        )
        .fold(0.0, (sum, expense) => sum + expense.amount);

    //Category Totals
    final categoryTotal = {
      for (final category in categories)
        category: expenses
            .where((expense) => expense.category == category)
            .fold(0.0, (sum, expense) => sum + expense.amount),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DashboardCard(
                title: 'TOTAL EXPENSE',
                value: CurrencyHelper.convert(
                  amount: totalExpense,
                  exchangeRate: exchangeRate,
                ),
                decimalplace: 2,
              ),
              DashboardCard(
                title: 'NUMBER OF EXPENSES',
                value: expenses.length,
                decimalplace: 0,
              ),
              DashboardCard(
                title: 'HIGHEST EXPENSE',
                value: CurrencyHelper.convert(
                  amount: highestExpense,
                  exchangeRate: exchangeRate,
                ),
                decimalplace: 2,
              ),
              DashboardCard(
                title: 'CURRENT MONTH\'S EXPENSE',
                value: CurrencyHelper.convert(
                  amount: currentMonthsExpense,
                  exchangeRate: exchangeRate,
                ),
                decimalplace: 2,
              ),
            ],
          ),

          SizedBox(height: height * 0.06),
          Text(
            'CATEGORY WISE SUMMARY:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: height * 0.025),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final total = categoryTotal[category] ?? 0.0;

                return SizedBox(
                  child: Card(
                    color: const Color.fromARGB(255, 222, 221, 221),
                    margin: EdgeInsets.only(
                      left: width * 0.25,
                      right: width * 0.25,
                      top: height * 0.05,
                    ),
                    child: ListTile(
                      title: Text('$category'),
                      trailing: Text(
                        '${CurrencyHelper.convert(amount: total, exchangeRate: exchangeRate).toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
