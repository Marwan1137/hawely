import 'package:dio/dio.dart'; // Dio package for HTTP requests
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication package
import 'package:get_it/get_it.dart'; // Dependency injection package
import 'package:hawely/Features/Auth/models/repsoitories/auth_repository.dart'; // AuthRepository for authentication logic
import 'package:hawely/Features/Auth/viewmodel/auth_viewmodel.dart'; // AuthViewModel for managing authentication state
import 'package:hawely/Features/HomeScreen/model/repositories/currency_reository.dart'; // CurrencyRepository for handling currency data
import 'package:hawely/Features/HomeScreen/viewmodel/currency_viewmodel.dart'; // CurrencyViewModel for managing currency state
import 'package:hawely/core/constants.dart'; // App constants file
import 'package:hawely/core/services/api_service.dart'; // ApiService for API interactions
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences for local storage

final GetIt serviceLocator = GetIt.instance; // Service locator instance

/* -------------------------------------------------------------------------- */
/*                      Setup Service Locator Function                       */
/* -------------------------------------------------------------------------- */
Future<void> setupServiceLocator() async {
  /* -------------------------- Register DIO Client ------------------------- */
  serviceLocator.registerSingleton<Dio>(
    Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl, // Base URL for API requests
        headers: {
          'Content-Type': 'application/json', // Set content type to JSON
        },
        connectTimeout: const Duration(seconds: 10), // Connection timeout
        receiveTimeout: const Duration(seconds: 10), // Response timeout
      ),
    ),
  );

  /* ------------------------- Register ApiService ------------------------- */
  serviceLocator.registerLazySingleton<ApiService>(
    () => ApiService(), // Lazy initialization of ApiService
  );

  /* -------------------- Register CurrencyRepository -------------------- */
  serviceLocator.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepository(
        serviceLocator<ApiService>()), // Initialize with ApiService
  );

  try {
    // Initialize SharedPreferences
    final prefs =
        await SharedPreferences.getInstance(); // Get SharedPreferences instance
    serviceLocator.registerSingleton<SharedPreferences>(
        prefs); // Register SharedPreferences
  } catch (e) {
    // Handle SharedPreferences initialization error
    print('Error initializing SharedPreferences: $e');
  }

  /* -------------------- Register AuthRepository -------------------- */
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepository(FirebaseAuth.instance), // Initialize with FirebaseAuth
  );

  /* -------------------- Register AuthViewModel -------------------- */
  serviceLocator.registerFactory<AuthViewModel>(
    () => AuthViewModel(
        serviceLocator<AuthRepository>()), // Initialize with AuthRepository
  );

  /* -------------------- Register CurrencyViewModel -------------------- */
  serviceLocator.registerFactory<CurrencyViewmodel>(
    () => CurrencyViewmodel(
      apiService: serviceLocator<ApiService>(), // Inject ApiService
      prefs: serviceLocator<SharedPreferences>(), // Inject SharedPreferences
      authVM: serviceLocator<AuthViewModel>(), // Inject AuthViewModel
    ),
  );
}
