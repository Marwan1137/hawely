import 'package:hawely/Features/HomeScreen/model/currency_model.dart';
import 'package:hawely/core/services/api_service.dart';

class CurrencyRepository {
  final ApiService _apiService;

  CurrencyRepository(this._apiService);

  Future<List<CurrencyModel>> getCurrencies() async {
    try {
      // Call fetchCurrencyRates from ApiService to get the List of CurrencyModel
      final List<CurrencyModel> currencies =
          await _apiService.fetchCurrencyRates();
      return currencies; // Return the list of CurrencyModel objects
    } catch (e) {
      throw Exception('Error in repository: $e');
    }
  }
}
