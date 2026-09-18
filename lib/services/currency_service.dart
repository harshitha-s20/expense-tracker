import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/currency.dart';

class CurrencyService {
  Future<List<Currency>> getExchangeRates() async {
    final url = Uri.parse('https://api.frankfurter.dev/v2/rates?base=INR');

    try {
      final response = await http.get(url).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((json) => Currency.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load exchange rates: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw Exception('Unable to retrieve exchange rate.');
    } catch (e) {
      throw Exception('Unable to fetch exchange rate: $e');
    }
  }

  //selected currency rate
  Future<double> getExchangeRate(String currency) async {
    final currencies = await getExchangeRates();
    final matchingCurrencies = currencies
        .where((item) => item.quote == currency)
        .toList();

    if (matchingCurrencies.isEmpty) {
      throw Exception('Exchange rate not found for $currency');
    }

    return matchingCurrencies.first.rate;
  }
}
