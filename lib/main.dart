import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hawely/Features/AccountData/view/account_details_screen.dart';
import 'package:hawely/Features/AccountData/viewmodel/account_viewmodel.dart';
import 'package:hawely/Features/Auth/models/repsoitories/auth_repository.dart';
import 'package:hawely/Features/Auth/viewmodel/auth_viewmodel.dart';
import 'package:hawely/Features/HomeScreen/view/home_screen.dart';
import 'package:hawely/Features/SettingsScreen/view/settings_screen.dart';
import 'package:hawely/Features/Auth/view/authscreen.dart';
import 'package:hawely/core/services/api_service.dart';
import 'package:hawely/shared/widgets/apptheme.dart';
import 'package:hawely/core/services/service_locator.dart';
import 'package:hawely/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:hawely/Features/HomeScreen/viewmodel/currency_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs =
      await SharedPreferences.getInstance(); // Initialize prefs

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupServiceLocator();
  runApp(
    MultiProvider(
      providers: [
        // Provide SharedPreferences
        Provider<SharedPreferences>(create: (_) => prefs),

        // Provide AuthRepository
        Provider<AuthRepository>(
          create: (context) => AuthRepository(FirebaseAuth.instance),
        ),

        // Provide AuthViewModel
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(context.read<AuthRepository>()),
        ),

        // Provide AccountViewModel
        ChangeNotifierProxyProvider<AuthViewModel, AccountViewModel>(
          create: (context) => AccountViewModel(context.read<AuthViewModel>()),
          update: (context, authVM, accountVM) =>
              accountVM!..updateAuthViewModel(authVM),
        ),

        // Provide CurrencyViewmodel
        ChangeNotifierProxyProvider<AuthViewModel, CurrencyViewmodel>(
          create: (context) => CurrencyViewmodel(
            apiService: context.read<ApiService>(),
            prefs: prefs, // Pass the initialized SharedPreferences
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => serviceLocator<CurrencyViewmodel>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Apptheme.lightTheme,
        home: AuthScreen(),
        //initialRoute: '/',
        routes: {
          '/home': (context) => const HomeScreen(),
          '/accountdata': (context) => const AccountDetailsScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
