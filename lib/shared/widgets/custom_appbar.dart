// custom_app_bar.dart

import 'package:flutter/material.dart'; // Flutter's material design package
import 'package:hawely/shared/widgets/apptheme.dart'; // App theme constants
import 'gradient_text.dart'; // Custom GradientText widget

/* -------------------------------------------------------------------------- */
/*                            Custom App Bar Class                            */
/* -------------------------------------------------------------------------- */
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title1; // First title displayed in the app bar
  final String title2; // Second title displayed in the app bar
  final List<Color> colors; // Gradient colors for the titles
  final Duration duration; // Duration for gradient animation
  final bool
      automaticallyImplyLeading; // Whether to show the back button or not

  /* -------------------------------------------------------------------------- */
  /*                              Constructor                                  */
  /* -------------------------------------------------------------------------- */
  const CustomAppBar({
    required this.title1, // Required: First title
    required this.title2, // Required: Second title
    required this.colors, // Required: Gradient colors
    this.duration = const Duration(seconds: 4), // Default animation duration
    this.automaticallyImplyLeading = true, // Default to showing the back button
    super.key,
  });

  /* -------------------------------------------------------------------------- */
  /*                              Build Method                                 */
  /* -------------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading:
          automaticallyImplyLeading, // Show back button if true
      iconTheme: const IconThemeData(
        color: Colors.white, // Set the back arrow color to white
      ),
      elevation: 0, // Remove shadow from the app bar
      backgroundColor:
          Apptheme.blackwithblue, // Custom app bar background color
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(32), // Rounded corners for the app bar
      ),
      toolbarHeight: 140, // Height of the app bar
      title: Column(
        children: [
          // First gradient title
          Center(
            child: GradientText(
              text: title1, // Text for the first title
              colors: colors, // Gradient colors for the text
              style: const TextStyle(
                fontSize: 30, // Font size for the first title
                fontWeight: FontWeight.bold, // Bold text
              ),
              duration: duration, // Animation duration for the gradient
            ),
          ),
          // Second gradient title
          Center(
            child: GradientText(
              text: title2, // Text for the second title
              colors: colors, // Gradient colors for the text
              style: const TextStyle(
                fontSize: 25, // Font size for the second title
                fontWeight: FontWeight.bold, // Bold text
              ),
              duration: duration, // Animation duration for the gradient
            ),
          ),
        ],
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                     Preferred Size for App Bar                            */
  /* -------------------------------------------------------------------------- */
  @override
  Size get preferredSize => const Size.fromHeight(120); // App bar height
}
