class CurrencyHelper {
  static double convert({
    required double amount,
    required double exchangeRate,
  }) {
    return amount * exchangeRate;
  }

  static double convertToINR({
    required double amount,
    required double exchangeRate,
  }) {
    if (exchangeRate == 0) {
      throw Exception('Exchange rate cannot be zero');
    }

    return amount / exchangeRate;
  }

  static String format({
    required double amount,
    required String quote,
    required double exchangeRate,
  }) {
    final convertedAmount = amount * exchangeRate;
    return '$quote ${convertedAmount.toStringAsFixed(2)}';
  }
}
