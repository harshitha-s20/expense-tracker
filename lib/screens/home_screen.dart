import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/screens/dashboard_screen.dart';
import 'package:expense_tracker/screens/expense_screen.dart';
import 'package:expense_tracker/screens/statistics_screen.dart';
import 'package:expense_tracker/screens/add_expense_screen.dart';

List<Expense> expenses = [];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  //List<Expense> expenses = [];
  String selectedCurrency = 'INR';
  double exchangeRate = 1.0;

  void addExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
    });
  }

  void deleteExpense(int id) {
    setState(() {
      expenses.removeWhere((expense) => expense.id == id);
    });
  }

  void updateExpense(Expense updatedExpense) {
    setState(() {
      final index = expenses.indexWhere(
        (expense) => expense.id == updatedExpense.id,
      );
      if (index != -1) {
        expenses[index] = updatedExpense;
      }
    });
  }

  void updateCurrency({required String currency, required double rate}) {
    setState(() {
      selectedCurrency = currency;
      exchangeRate = rate;
    });
  }

  Widget getCurrentScreen() {
    switch (selectedIndex) {
      case 0:
        return Dashboard(
          expenses: expenses,
          selectedCurrency: selectedCurrency,
          exchangeRate: exchangeRate,
        );
      case 1:
        return ExpenseScreen(
          expenses: expenses,
          onDelete: deleteExpense,
          onUpdate: updateExpense,
          selectedCurrency: selectedCurrency,
          exchangeRate: exchangeRate,
        );
      case 2:
        return StatisticsScreen(
          expenses: expenses,
          selectedCurrency: selectedCurrency,
          exchangeRate: exchangeRate,
        );
      default:
        return Dashboard(
          expenses: expenses,
          selectedCurrency: selectedCurrency,
          exchangeRate: exchangeRate,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        backgroundColor: const Color.fromARGB(221, 150, 124, 124),
        actions: [
          Text('Currency: $selectedCurrency\t\t '),
          IconButton(
            padding: EdgeInsets.only(right: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    selectedCurrency: selectedCurrency,
                    exchangeRate: exchangeRate,
                    onCurrencyChanged: updateCurrency,
                  ),
                ),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: getCurrentScreen(),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newExpense = await Navigator.push<Expense>(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(
                selectedCurrency: selectedCurrency,
                exchangeRate: exchangeRate,
              ),
            ),
          );
          if (newExpense != null) {
            addExpense(newExpense);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Expense added successfully!!'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Expenses'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
        ],
      ),
    );
  }
}
