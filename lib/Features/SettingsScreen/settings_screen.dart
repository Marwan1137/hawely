import 'package:flutter/material.dart';
import 'package:hawely/Features/HomeScreen/widgets/custom_appbar.dart';
import 'package:hawely/Features/HomeScreen/widgets/custom_bottom_appbar.dart';
import 'package:hawely/apptheme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Hawely',
        title2: 'Currency Converter',
        colors: [Apptheme.blue, Apptheme.darkred],
      ),
      bottomNavigationBar: CustomBottomAppbar(),
      body: Center(
        child: Text(
          'Settings Screen',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
    );
  }
}
