import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/screens/edit_expense_screen.dart';
import 'package:expense_tracker/widgets/currency_helper.dart';
import 'package:flutter/material.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;
  final Function(Expense) onUpdate;
  final String selectedCurrency;
  final double exchangeRate;

  const ExpenseDetailsScreen({
    super.key,
    required this.expense,
    required this.onDelete,
    required this.onUpdate,
    required this.selectedCurrency,
    required this.exchangeRate,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('Expense Detaits')),
      body: Center(
        child: Card(
          margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
          child: SizedBox(
            //width: width * 0.3,
            height: height * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '$expense.title',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  'Amount : ${CurrencyHelper.convert(amount: expense.amount, exchangeRate: exchangeRate).toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  'Category : ${expense.category}',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  'Date : ${expense.date.day}/'
                  '${expense.date.month}/'
                  '${expense.date.year}',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  'Note : ${expense.notes ?? 'No notes'}',
                  style: TextStyle(fontSize: 15),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final updatedExpense = await Navigator.push<Expense>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditExpenseScreen(
                              expense: expense,
                              selectedCurrency: selectedCurrency,
                              exchangeRate: exchangeRate,
                            ),
                          ),
                        );
                        if (updatedExpense != null) {
                          onUpdate(updatedExpense);
                          Navigator.pop(context);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [Icon(Icons.edit), Text('Edit')],
                      ),
                    ),

                    SizedBox(width: width * 0.05),

                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Delete Expense'),
                              content: Text(
                                'Are you sure you want to delete this expense?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    onDelete();
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Expense deleteed successfully',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [Icon(Icons.delete), Text('Delete')],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
