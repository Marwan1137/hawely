class CurrencyModel {
  final String code;
  final double rate; // Original rate from API (relative to default base)
  final bool isBaseCurrency;

  CurrencyModel({
    required this.code,
    required this.rate,
    this.isBaseCurrency = false,
  });

  CurrencyModel copyWith({
    double? convertedRate,
    bool? isBaseCurrency,
  }) {
    return CurrencyModel(
      code: code,
      rate: convertedRate ?? rate,
      isBaseCurrency: isBaseCurrency ?? this.isBaseCurrency,
    );
  }

  // New method to calculate converted rates
  double get convertedRate {
    if (isBaseCurrency) return 1.0;
    return rate;
  }

  factory CurrencyModel.fromJson(String code, dynamic rate) {
    return CurrencyModel(
      code: code,
      rate: double.tryParse(rate.toString()) ?? 0.0,
    );
  }
}
