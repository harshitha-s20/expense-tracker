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

    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;

    final boxHeight = isPortrait ? height * 0.4 : height * 0.55;

    final double menuLength = isPortrait ? 300 : 250;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 232, 242, 255),
      appBar: AppBar(
        backgroundColor: Color(0xFF234E70),
        foregroundColor: Colors.white,
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: width * 0.5,
            height: boxHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Currency',
                  style: TextStyle(
                    color: Color(0xFF263B53),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (isLoading)
                  Center(
                    child: CircularProgressIndicator(color: Color(0xFF7562D9)),
                  ),

                if (errorMessage != null)
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Unable to retrieve exchange rate.',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: fetchCurrencies,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF8F3FF),
                            foregroundColor: const Color(0xFF7562D9),
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'Retry',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (!isLoading && errorMessage == null)
                  DropdownMenu<String>(
                    menuHeight: menuLength,
                    hintText: 'Select Currency',
                    enableFilter: true,
                    enableSearch: true,

                    textStyle: const TextStyle(
                      color: Color(0xFF263B53),
                      fontSize: 16,
                    ),

                    trailingIcon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF5F6570),
                    ),
                    selectedTrailingIcon: const Icon(
                      Icons.arrow_drop_up,
                      color: Color(0xFF5F6570),
                    ),
                    // padding: EdgeInsets.only(left: width * 0.3),
                    initialSelection: selectedCurrencyN,
                    inputDecorationTheme: InputDecorationTheme(
                      hintStyle: const TextStyle(
                        color: Color(0xFF5F6570),
                        fontSize: 16,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 17,
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF8A8A8A),
                          width: 1.8,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF8A8A8A),
                          width: 1.8,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF28577A),
                          width: 1.8,
                        ),
                      ),
                    ),

                    menuStyle: MenuStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Color(0xFFF9F7FF),
                      ),
                    ),

                    dropdownMenuEntries: currencyList.map((currency) {
                      return DropdownMenuEntry<String>(
                        value: currency,
                        label: currency,
                      );
                    }).toList(),
                    onSelected: (value) {
                      if (value != null) {
                        selectCurrency(value);
                      }
                    },
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7567D9),
                    foregroundColor: Colors.white,
                    elevation: 2,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 12,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: submitCurrency,
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),

                Text('Current Currency: $selectedCurrencyN'),

                Text('Exchange Rate: $selectedExchangeRate'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
