import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/currency_helper.dart';
import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final String selectedCurrency;
  final double exchangeRate;
  const ExpenseCard({
    super.key,
    required this.expense,
    required this.selectedCurrency,
    required this.exchangeRate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            expense.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category: ${expense.category}',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  'Date: '
                  '${expense.date.day}/'
                  '${expense.date.month}/'
                  '${expense.date.year}',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          trailing: Text(
            'Amount: ${CurrencyHelper.format(amount: expense.amount, exchangeRate: exchangeRate, quote: selectedCurrency)}',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
