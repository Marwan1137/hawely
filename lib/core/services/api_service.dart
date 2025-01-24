import 'package:dio/dio.dart';
import 'package:hawely/core/constants.dart';
import 'package:hawely/Features/HomeScreen/model/currency_model.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));

  Future<List<CurrencyModel>> fetchCurrencyRates(
      {String baseCurrency = 'USD'}) async {
    try {
      final response = await _dio.get(
        '/v6/${AppConstants.apiKey}/latest/$baseCurrency',
      );

      if (response.statusCode == 200) {
        final data = response.data['conversion_rates'] as Map<String, dynamic>;
        return data.entries
            .map((entry) => CurrencyModel.fromJson(entry.key, entry.value))
            .toList();
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch rates: ${e.message}');
    }
  }
}
