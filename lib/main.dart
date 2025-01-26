import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hawely/Features/AccountData/account_data.dart';
import 'package:hawely/Features/Auth/models/repsoitories/auth_repository.dart';
import 'package:hawely/Features/Auth/viewmodel/auth_viewmodel.dart';
import 'package:hawely/Features/HomeScreen/view/home_screen.dart';
import 'package:hawely/Features/SettingsScreen/view/settings_screen.dart';
import 'package:hawely/Features/Auth/view/authscreen.dart';
import 'package:hawely/apptheme.dart';
import 'package:hawely/core/services/service_locator.dart';
import 'package:hawely/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:hawely/Features/HomeScreen/viewmodel/currency_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupServiceLocator();
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (context) => AuthRepository(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(context.read<AuthRepository>()),
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
