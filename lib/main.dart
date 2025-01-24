import 'package:flutter/material.dart';
import 'package:hawely/Features/AccountData/account_data.dart';
import 'package:hawely/Features/CurrencyScreen/currency_screen.dart';
import 'package:hawely/Features/HomeScreen/view/home_screen.dart';
import 'package:hawely/Features/SettingsScreen/view/settings_screen.dart';
import 'package:hawely/apptheme.dart';
import 'package:hawely/core/services/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:hawely/Features/HomeScreen/viewmodel/currency_viewmodel.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
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
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/currency': (context) => CurrencyScreen(),
          '/accountdata': (context) => const AccountDetailsScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
