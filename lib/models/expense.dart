class Expense {
  final int id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String? notes;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.notes,
  });
}
