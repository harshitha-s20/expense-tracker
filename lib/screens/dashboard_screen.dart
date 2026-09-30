import 'package:expense_tracker/screens/add_expense_screen.dart';
import 'package:expense_tracker/widgets/currency_helper.dart';
import 'package:expense_tracker/widgets/dashboard_card.dart';
import 'package:expense_tracker/widgets/expense_card.dart';
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
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;

    //Total Expense
    final double totalExpense = expenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );

    final convertedTotal = totalExpense * exchangeRate;
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
      backgroundColor: Color.fromARGB(255, 232, 242, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 232, 242, 255),
        foregroundColor: Color(0xFF172B4D),
        title: Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
      ),
      body: isPortrait
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Wrap(
                      spacing: 15,
                      runSpacing: 15,
                      children: [
                        DashboardCard(
                          title: 'TOTAL EXPENSE',
                          value: convertedTotal,
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

                    SizedBox(height: height * 0.035),
                    Text(
                      'CATEGORY WISE SUMMARY:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF172B4D),
                      ),
                    ),

                    //SizedBox(height: 20),
                    Flexible(
                      child: ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final total = categoryTotal[category] ?? 0.0;

                          return SizedBox(
                            child: Card(
                              color: Colors.white,
                              margin: EdgeInsets.only(
                                left: width * 0.15,
                                right: width * 0.15,
                                top: height * 0.03,
                              ),

                              child: ListTile(
                                leading: Container(
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

                                title: Text(
                                  '$category',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF172B4D),
                                  ),
                                ),

                                trailing: Text(
                                  '${CurrencyHelper.convert(amount: total, exchangeRate: exchangeRate).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 44, 130, 121),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      // Dashboard cards
                      Wrap(
                        spacing: 15,
                        runSpacing: 15,
                        children: [
                          DashboardCard(
                            title: 'TOTAL EXPENSE',
                            value: convertedTotal,
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

                      SizedBox(height: height * 0.035),

                      Text(
                        'CATEGORY WISE SUMMARY:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF172B4D),
                        ),
                      ),

                      SizedBox(height: 10),

                      // Category list
                      ...categories.map((category) {
                        final total = categoryTotal[category] ?? 0.0;

                        return Card(
                          color: Colors.white,
                          margin: EdgeInsets.only(
                            left: width * 0.15,
                            right: width * 0.15,
                            bottom: 10,
                          ),
                          child: ListTile(
                            leading: Container(
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

                            title: Text(
                              category,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF172B4D),
                              ),
                            ),

                            trailing: Text(
                              CurrencyHelper.convert(
                                amount: total,
                                exchangeRate: exchangeRate,
                              ).toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 44, 130, 121),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
