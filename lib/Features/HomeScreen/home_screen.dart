import 'package:flutter/material.dart';
import 'package:hawely/Features/HomeScreen/widgets/custom_appbar.dart';
import 'package:hawely/Features/HomeScreen/widgets/custom_bottom_appbar.dart';
import 'package:hawely/apptheme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Hawely',
        title2: 'Currency Converter',
        colors: [
          Apptheme.blue, // Blue
          Apptheme.darkred, // Dark Red
        ],
        duration: Duration(seconds: 4),
      ),
      bottomNavigationBar: CustomBottomAppbar(),
    );
  }
}
