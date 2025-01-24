import 'package:flutter/material.dart';
import 'package:hawely/widgets/custom_appbar.dart';
import 'package:hawely/widgets/custom_bottom_appbar.dart';
import 'package:hawely/apptheme.dart';

class AccountDetailsScreen extends StatelessWidget {
  const AccountDetailsScreen({super.key});

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
          'Account Details',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
    );
  }
}
