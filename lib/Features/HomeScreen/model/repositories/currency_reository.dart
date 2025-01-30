/* -------------------------------------------------------------------------- */
/*                          CurrencyRepository Class                          */
/* -------------------------------------------------------------------------- */
import 'package:hawely/Features/HomeScreen/model/currency_model.dart';
import 'package:hawely/core/services/api_service.dart';

class CurrencyRepository {
  final ApiService _apiService; // API service for fetching currency data

  /* -------------------------------------------------------------------------- */
  /*                              Constructor                                  */
  /* -------------------------------------------------------------------------- */
  CurrencyRepository(
      this._apiService); // Initialize with an instance of ApiService

  /* -------------------------------------------------------------------------- */
  /*                      Fetch Currencies from API Service                    */
  /* -------------------------------------------------------------------------- */
  Future<List<CurrencyModel>> getCurrencies() async {
    try {
      // Call fetchCurrencyRates from ApiService to get the list of CurrencyModel objects
      final List<CurrencyModel> currencies =
          await _apiService.fetchCurrencyRates();
      return currencies; // Return the list of CurrencyModel objects
    } catch (e) {
      throw Exception('Error in repository: $e'); // Handle and throw exceptions
    }
  }
}
