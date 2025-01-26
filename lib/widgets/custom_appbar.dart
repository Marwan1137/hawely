// custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:hawely/apptheme.dart';
import 'gradient_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title1;
  final String title2;
  final List<Color> colors;
  final Duration duration;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    required this.title1,
    required this.title2,
    required this.colors,
    this.duration = const Duration(seconds: 4),
    this.automaticallyImplyLeading = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      iconTheme: IconThemeData(
        color: Colors.white, // Set the back arrow color to white
      ),
      elevation: 0,
      backgroundColor: Apptheme.blackwithblue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      toolbarHeight: 140,
      title: Column(
        children: [
          Center(
            child: GradientText(
              text: title1,
              colors: colors,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              duration: duration,
            ),
          ),
          Center(
            child: GradientText(
              text: title2,
              colors: colors,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              duration: duration,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(120);
}
