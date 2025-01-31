/* -------------------------------------------------------------------------- */
/*                          CurrencyModel Class                               */
/* -------------------------------------------------------------------------- */
class CurrencyModel {
  final String code; // Currency code (e.g., USD, EUR)
  final double rate; // Original rate from API (relative to default base)
  final bool isBaseCurrency; // Whether this currency is the base currency

  /* -------------------------------------------------------------------------- */
  /*                              Constructor                                  */
  /* -------------------------------------------------------------------------- */
  CurrencyModel({
    required this.code,
    required this.rate,
    this.isBaseCurrency = false, // Default to false if not specified
  });

  /* -------------------------------------------------------------------------- */
  /*                          CopyWith Method                                  */
  /* -------------------------------------------------------------------------- */
  CurrencyModel copyWith({
    double? convertedRate, // Optional new rate for conversion
    bool? isBaseCurrency, // Optional new value for isBaseCurrency
  }) {
    return CurrencyModel(
      code: code,
      rate: convertedRate ?? rate, // Use existing rate if not provided
      isBaseCurrency: isBaseCurrency ??
          this.isBaseCurrency, // Use existing value if not provided
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                          Calculate Converted Rate                         */
  /* -------------------------------------------------------------------------- */
  double get convertedRate {
    if (isBaseCurrency) return 1.0; // Base currency always has a rate of 1.0
    return rate; // Return the original rate for non-base currencies
  }

  /* -------------------------------------------------------------------------- */
  /*                          Factory Method for JSON Parsing                  */
  /* -------------------------------------------------------------------------- */
  factory CurrencyModel.fromJson(String code, dynamic rate) {
    return CurrencyModel(
      code: code, // Currency code from JSON
      rate: double.tryParse(rate.toString()) ??
          0.0, // Parse rate from JSON or default to 0.0
    );
  }
}
