import 'package:flutter/material.dart'; // Flutter framework for UI components
import 'package:hawely/shared/widgets/apptheme.dart'; // Custom theme definitions

/* -------------------------------------------------------------------------- */
/*                         CustomBottomAppbar Widget                          */
/* -------------------------------------------------------------------------- */
class CustomBottomAppbar extends StatelessWidget {
  const CustomBottomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Height of the bottom app bar
      width: double.infinity, // Full width of the screen
      decoration: BoxDecoration(
        color: Apptheme.blackwithblue, // Background color from the theme
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32), // Rounded top corners
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Space icons evenly
        children: [
          /* ----------------------- Currency Exchange Button ----------------------- */
          IconButton(
            icon: Icon(
              Icons.currency_exchange_outlined, // Currency exchange icon
              size: 30, // Icon size
              color: Apptheme.white, // Icon color from the theme
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, '/home'); // Navigate to home
            },
          ),
          /* -------------------------- Account Data Button -------------------------- */
          IconButton(
            icon: Icon(
              Icons.account_circle, // Account circle icon
              size: 30, // Icon size
              color: Apptheme.white, // Icon color from the theme
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, '/accountdata'); // Navigate to account data
            },
          ),
        ],
      ),
    );
  }
}
