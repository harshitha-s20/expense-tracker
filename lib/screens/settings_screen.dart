import 'package:expense_tracker/models/currency.dart';
import 'package:expense_tracker/services/currency_service.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String selectedCurrency;
  final double exchangeRate;

  final Function({required String currency, required double rate})
  onCurrencyChanged;

  const SettingsScreen({
    super.key,
    required this.selectedCurrency,
    required this.exchangeRate,
    required this.onCurrencyChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  final CurrencyService currencyService = CurrencyService();
  List<Currency> currencies = [];
  List<String> currencyList = [];
  bool isLoading = false;
  String? errorMessage;
  String? selectedCurrencyN;
  double? selectedExchangeRate;

  @override
  void initState() {
    super.initState();
    selectedCurrencyN = widget.selectedCurrency;
    selectedExchangeRate = widget.exchangeRate;
    fetchCurrencies();
  }

  Future<void> fetchCurrencies() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await currencyService.getExchangeRates();

      setState(() {
        currencies = result;
        currencyList = currencies.map((currency) => currency.quote).toList();

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Unable to retrieve exchange rate.';
      });
    }
  }

  void selectCurrency(String currency) {
    try {
      final matchingCurrency = currencies.firstWhere(
        (item) => item.quote == currency,
      );

      final latestRate = matchingCurrency.rate;

      setState(() {
        selectedCurrencyN = currency;
        selectedExchangeRate = latestRate;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  void submitCurrency() {
    if (selectedCurrencyN == null || selectedExchangeRate == null) {
      return;
    }
    widget.onCurrencyChanged(
      currency: selectedCurrencyN!,
      rate: selectedExchangeRate!,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Currency changed to $selectedCurrencyN')),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: SizedBox(
          width: width * 0.5,
          height: height * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Currency',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),

              if (isLoading) Center(child: CircularProgressIndicator()),

              if (errorMessage != null)
                Center(
                  child: Column(
                    children: [
                      Text('Unable to retrieve exchange rate.'),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: fetchCurrencies,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                ),

              // if (!isLoading && errorMessage != null)
              //   Text(errorMessage!, style: TextStyle(color: Colors.red)),
              if (!isLoading && errorMessage == null)
                DropdownButtonFormField<String>(
                  // padding: EdgeInsets.only(left: width * 0.3),
                  initialValue: selectedCurrencyN,
                  decoration: InputDecoration(
                    hintText: 'Select Currency',
                    border: OutlineInputBorder(),
                  ),
                  items: currencyList.map((currency) {
                    return DropdownMenuItem<String>(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectCurrency(value);
                    }
                  },
                ),
              ElevatedButton(onPressed: submitCurrency, child: Text('Submit')),

              Text('Current Currency: ${selectedCurrencyN}'),

              Text('Exchange Rate: ${selectedExchangeRate}'),
            ],
          ),
        ),
      ),
    );
  }
}
