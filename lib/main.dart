import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication
import 'package:firebase_core/firebase_core.dart'; // Firebase initialization
import 'package:flutter/material.dart'; // Flutter UI components
import 'package:hawely/Features/AccountData/view/account_details_screen.dart'; // Account details screen
import 'package:hawely/Features/AccountData/viewmodel/account_viewmodel.dart'; // Account viewmodel
import 'package:hawely/Features/Auth/models/repsoitories/auth_repository.dart'; // Auth repository
import 'package:hawely/Features/Auth/viewmodel/auth_viewmodel.dart'; // Auth viewmodel
import 'package:hawely/Features/HomeScreen/view/home_screen.dart'; // Home screen
import 'package:hawely/Features/SettingsScreen/view/settings_screen.dart'; // Settings screen
import 'package:hawely/Features/Auth/view/authscreen.dart'; // Auth screen
import 'package:hawely/core/services/api_service.dart'; // API service
import 'package:hawely/shared/widgets/apptheme.dart'; // Theme
import 'package:hawely/core/services/service_locator.dart'; // Service locator
import 'package:hawely/firebase_options.dart'; // Firebase options
import 'package:provider/provider.dart'; // State management
import 'package:hawely/Features/HomeScreen/viewmodel/currency_viewmodel.dart'; // Currency viewmodel
import 'package:shared_preferences/shared_preferences.dart'; // Shared preferences

/* -------------------------------------------------------------------------- */
/*                               Main Function                                */
/* -------------------------------------------------------------------------- */
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  /* ---------------------------- Initialize Firebase --------------------------- */
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupServiceLocator(); // Setup service locator

  runApp(
    MultiProvider(
      providers: [
        /* ------------------------ Provide SharedPreferences ----------------------- */
        Provider<SharedPreferences>(create: (_) => prefs),

        /* ------------------------- Provide AuthRepository ------------------------- */
        Provider<AuthRepository>(
          create: (context) => AuthRepository(FirebaseAuth.instance),
        ),

        /* ------------------------- Provide AuthViewModel -------------------------- */
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(context.read<AuthRepository>()),
        ),

        /* ------------------------ Provide AccountViewModel ------------------------ */
        ChangeNotifierProxyProvider<AuthViewModel, AccountViewModel>(
          create: (context) => AccountViewModel(context.read<AuthViewModel>()),
          update: (context, authVM, accountVM) =>
              accountVM!..updateAuthViewModel(authVM),
        ),

        /* ------------------------ Provide CurrencyViewmodel ----------------------- */
        ChangeNotifierProxyProvider<AuthViewModel, CurrencyViewmodel>(
          create: (context) => CurrencyViewmodel(
            apiService: context.read<ApiService>(),
            prefs: prefs, // Pass SharedPreferences
            authVM: context.read<AuthViewModel>(),
          ),
          update: (context, authVM, currencyVM) =>
              currencyVM!..updateAuthVM(authVM),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

/* -------------------------------------------------------------------------- */
/*                                MyApp Widget                                */
/* -------------------------------------------------------------------------- */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => serviceLocator<CurrencyViewmodel>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Hide debug banner
        theme: Apptheme.lightTheme, // Set light theme
        home: AuthScreen(), // Set the initial screen
        routes: {
          '/home': (context) => const HomeScreen(), // Route to home screen
          '/accountdata': (context) =>
              const AccountDetailsScreen(), // Route to account data
          '/settings': (context) =>
              const SettingsScreen(), // Route to settings screen
        },
      ),
    );
  }
}
