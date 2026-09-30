import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/currency_helper.dart';
import 'package:flutter/material.dart';

IconData getCategoryIcon(String category) {
  switch (category) {
    case 'Food':
      return Icons.restaurant;

    case 'Travel':
      return Icons.flight;

    case 'Shopping':
      return Icons.shopping_bag;

    case 'Bills':
      return Icons.receipt_long;

    case 'Entertainment':
      return Icons.movie;

    case 'Other':
      return Icons.more_horiz;
    default:
      return Icons.category;
  }
}

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
    double width = MediaQuery.of(context).size.width;

    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    final double marginWidth = isPortrait ? 20 : width * 0.1;

    return Card(
      margin: EdgeInsets.only(left: 20, right: marginWidth, bottom: 15),
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9F1F0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    getCategoryIcon(expense.category),
                    color: Color(0xFF258C88),
                    size: 25,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF173B63),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFD9F1F0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          expense.category,
                          style: TextStyle(
                            color: Color(0xFF258C88),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Color(0xFF8091AA), size: 28),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: Color(0xFF8091AA),
                  size: 20,
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date:',
                      style: TextStyle(
                        color: Color(0xFF8091AA),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '${expense.date.day.toString().padLeft(2, '0')}/'
                      '${expense.date.month.toString().padLeft(2, '0')}/'
                      '${expense.date.year}',
                      style: TextStyle(
                        color: Color(0xFF173B63),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Container(height: 40, width: 1, color: Color(0xFFD5DCE5)),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: TextStyle(
                        color: Color(0xFF8091AA),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      CurrencyHelper.format(
                        amount: expense.amount,
                        quote: selectedCurrency,
                        exchangeRate: exchangeRate,
                      ),
                      style: TextStyle(
                        color: Color(0xFF258C88),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
