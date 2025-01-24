import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hawely/Features/HomeScreen/model/repositories/currency_reository.dart';
import 'package:hawely/Features/HomeScreen/viewmodel/currency_viewmodel.dart';
import 'package:hawely/core/constants.dart';
import 'package:hawely/core/services/api_service.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  /* -------------------------- Register DIO Client ------------------------- */
  serviceLocator.registerSingleton<Dio>(
    Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    ),
  );

  /* ------------------------- Register ApiService ------------------------- */
  serviceLocator.registerLazySingleton<ApiService>(() => ApiService());

  /* -------------------- Register CurrencyRepository -------------------- */
  serviceLocator.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepository(serviceLocator<ApiService>()),
  );

  /* -------------------- Register CurrencyViewModel -------------------- */
  serviceLocator.registerFactory<CurrencyViewmodel>(
    () => CurrencyViewmodel(apiService: serviceLocator<ApiService>()),
  );
}
