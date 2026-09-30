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
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    final double boxHeight = isPortrait ? height * 0.5 : height * 0.55;
    final double marginWidth = isPortrait ? width * 0.05 : width * 0.2;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 232, 242, 255),
      appBar: AppBar(
        backgroundColor: Color(0xFF234E70),
        foregroundColor: Colors.white,
        title: Text(
          'Expense Detaits',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Card(
            elevation: 3,
            color: Colors.white,
            margin: EdgeInsets.only(left: marginWidth, right: marginWidth),
            child: SizedBox(
              height: boxHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '${expense.title}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF202020),
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Amount : ${CurrencyHelper.convert(amount: expense.amount, exchangeRate: exchangeRate).toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF424242),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Category : ${expense.category}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF424242),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Date : ${expense.date.day}/'
                    '${expense.date.month}/'
                    '${expense.date.year}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF424242),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Note : ${expense.notes ?? 'No notes'}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF424242),
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7567D9),
                          foregroundColor: Colors.white,
                        ),
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
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
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
      ),
    );
  }
}
