import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hawely/Features/Auth/models/repsoitories/auth_repository.dart';
import 'package:hawely/Features/Auth/viewmodel/auth_viewmodel.dart';
import 'package:hawely/Features/HomeScreen/model/repositories/currency_reository.dart';
import 'package:hawely/Features/HomeScreen/viewmodel/currency_viewmodel.dart';
import 'package:hawely/core/constants.dart';
import 'package:hawely/core/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
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

  try {
    // Initialize SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    serviceLocator.registerSingleton<SharedPreferences>(prefs);

    // Register other dependencies...
  } catch (e) {
    print('Error initializing SharedPreferences: $e');
  }
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepository(FirebaseAuth.instance),
  );

  serviceLocator.registerFactory<AuthViewModel>(
    () => AuthViewModel(serviceLocator<AuthRepository>()),
  );

  /* -------------------- Register CurrencyViewModel -------------------- */
  serviceLocator.registerFactory<CurrencyViewmodel>(
    () => CurrencyViewmodel(
      apiService: serviceLocator<ApiService>(),
      prefs: serviceLocator<SharedPreferences>(), // Add this
      authVM: serviceLocator<AuthViewModel>(), // Add this
    ),
  );
}
