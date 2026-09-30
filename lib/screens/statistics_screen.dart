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
    double height = MediaQuery.of(context).size.height;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    final double marginHeight = isPortrait ? height * 0.1 : height * 0.01;
    double paddingWidth = isPortrait ? 8 : width * 0.1;

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
        backgroundColor: Color.fromARGB(255, 232, 242, 255),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 232, 242, 255),
          foregroundColor: Color(0xFF172B4D),
          title: Text(
            'Statistics',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),

            child: Container(
              color: const Color(0xFFF1F6FC),

              child: TabBar(
                labelColor: Color(0xDD7562D9),
                unselectedLabelColor: Color(0xFF6B7280),
                indicatorColor: Color(0xFF7562D9),
                indicatorWeight: 3,
                tabs: [
                  Tab(text: 'Category'),
                  Tab(text: 'Recent'),
                ],
              ),
            ),
          ),
        ),

        body: SafeArea(
          child: TabBarView(
            children: [
              //Text('this is category'),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  paddingWidth,
                  10,
                  paddingWidth,
                  10,
                ),
                child: Card(
                  color: Colors.white,
                  shadowColor: Colors.black,
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: marginHeight),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final total = categoryTotals[category] ?? 0.0;
                      final progress = maxCategoryTotal == 0
                          ? 0.0
                          : total / maxCategoryTotal;

                      return Padding(
                        padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 42,
                                  width: 42,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFD9F1F0),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    getCategoryIcon(category),
                                    color: Color(0xFF258C88),
                                    size: 22,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      color: Color(0xFF173B63),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Text(
                                  CurrencyHelper.format(
                                    amount: total,
                                    exchangeRate: exchangeRate,
                                    quote: selectedCurrency,
                                  ),
                                  style: TextStyle(
                                    color: Color(0xFF258C88),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: const Color(0xFFE9E1FA),
                              color: const Color(0xFF7562D9),
                              minHeight: 7,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              expenses.isEmpty
                  ? Center(
                      child: Text(
                        'No recent expenses',
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ListView.builder(
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
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
