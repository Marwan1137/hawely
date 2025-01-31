import 'package:flutter/material.dart';

/* -------------------------------------------------------------------------- */
/*                          GradientButton Widget                            */
/* -------------------------------------------------------------------------- */
class GradientButton extends StatelessWidget {
  final String text; // Text to display on the button
  final VoidCallback onPressed; // Callback when the button is pressed
  final Gradient gradient; // Gradient for the button background
  final Icon? icon; // Optional icon to display alongside the text

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.gradient,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius:
          BorderRadius.circular(20), // Rounded corners for the tap area
      onTap: onPressed, // Handle button press
      child: Container(
        width: 350, // Fixed width for the button
        padding: const EdgeInsets.symmetric(
            horizontal: 30, vertical: 15), // Padding inside the button
        decoration: BoxDecoration(
          gradient: gradient, // Apply gradient background
          borderRadius:
              BorderRadius.circular(20), // Rounded corners for the container
        ),
        child: Row(
          children: [
            Center(
              child: Text(
                text, // Display button text
                style: const TextStyle(
                  color: Colors.white, // Text color
                  fontSize: 18, // Text size
                  fontWeight: FontWeight.bold, // Bold text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
