import 'package:dio/dio.dart'; // Dio package for making HTTP requests
import 'package:hawely/core/constants.dart'; // App constants file
import 'package:hawely/Features/HomeScreen/model/currency_model.dart'; // Currency model for mapping data

class ApiService {
  final Dio _dio; // Dio instance for handling API requests

  /* -------------------------------------------------------------------------- */
  /*                              Constructor                                  */
  /* -------------------------------------------------------------------------- */
  ApiService()
      : _dio = Dio(BaseOptions(
            baseUrl: AppConstants.baseUrl)); // Initialize Dio with base URL

  /* -------------------------------------------------------------------------- */
  /*                       Fetch Currency Rates Method                         */
  /* -------------------------------------------------------------------------- */
  Future<List<CurrencyModel>> fetchCurrencyRates(
      {String baseCurrency = 'USD'}) async {
    try {
      // Perform a GET request to fetch currency rates
      final response = await _dio.get(
        '/v6/${AppConstants.apiKey}/latest/$baseCurrency', // API endpoint with base currency
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse the conversion rates from the response
        final data = response.data['conversion_rates'] as Map<String, dynamic>;

        // Map the conversion rates to a list of CurrencyModel objects
        return data.entries
            .map((entry) => CurrencyModel.fromJson(entry.key, entry.value))
            .toList(); // Convert data to a list of CurrencyModel
      } else {
        // Throw an exception if the response is not successful
        throw Exception('API Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio-specific exceptions
      throw Exception('Failed to fetch rates: ${e.message}');
    }
  }
}
