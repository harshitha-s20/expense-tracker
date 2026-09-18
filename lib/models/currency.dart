class Currency {
  final String date;
  final String base;
  final String quote;
  final double rate;

  Currency({
    required this.date,
    required this.base,
    required this.quote,
    required this.rate,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      date: json['date'],
      base: json['base'],
      quote: json['quote'],
      rate: (json['rate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'base': base, 'quote': quote, 'rate': rate};
  }
}
