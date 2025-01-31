// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart'; // Swiper package for image carousel
import 'package:hawely/Features/Auth/view/sign_in_screen.dart'; // Sign-in screen
import 'package:hawely/Features/Auth/view/sign_up_screen.dart'; // Sign-up screen
import 'package:hawely/shared/widgets/apptheme.dart'; // App theme and colors
import 'package:hawely/shared/widgets/custom_appbar.dart'; // Custom app bar widget
import 'package:hawely/Features/Auth/view/components/gradient_button.dart'; // Gradient button widget

/* -------------------------------------------------------------------------- */
/*                              AuthScreen Widget                            */
/* -------------------------------------------------------------------------- */
class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final List<String> images = [
    'assets/currencyconverter1.jpg', // Image 1 for swiper
    'assets/currencyconverter3.png', // Image 2 for swiper
    'assets/currencyconverter2.png', // Image 3 for swiper
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent background
      body: Stack(
        children: [
          /* ------------------------------------------------------------------ */
          /*                          Swiper for Images                         */
          /* ------------------------------------------------------------------ */
          Positioned(
            top: 0, // Start from the top of the screen
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20), // Rounded bottom edges
              ),
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    images[index], // Load image from assets
                    fit: BoxFit.cover, // Cover the entire area
                  );
                },
                itemCount: images.length, // Number of images
                autoplay: true, // Automatically transition between images
                duration: 1000, // Transition duration in milliseconds
                autoplayDelay: 3000, // Delay between transitions
              ),
            ),
          ),

          /* ------------------------------------------------------------------ */
          /*                          Shaded Overlay                           */
          /* ------------------------------------------------------------------ */
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20), // Rounded bottom edges
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6), // Dark overlay at the top
                    Colors.black
                        .withOpacity(0.3), // Lighter overlay at the bottom
                  ],
                ),
              ),
            ),
          ),

          /* ------------------------------------------------------------------ */
          /*                              AppBar                                */
          /* ------------------------------------------------------------------ */
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomAppBar(
              title1: 'Welcome to Hawely', // First title
              title2: 'Currency Converter', // Second title
              colors: [Apptheme.blue, Apptheme.darkred], // Gradient colors
            ),
          ),

          /* ------------------------------------------------------------------ */
          /*                              Buttons                               */
          /* ------------------------------------------------------------------ */
          Positioned(
            bottom: 70, // Position buttons 70 pixels from the bottom
            left: 50,
            right: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Sign In Button
                GradientButton(
                  text: 'Sign In',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SignInScreen(), // Navigate to SignInScreen
                      ),
                    );
                  },
                  gradient: LinearGradient(
                    colors: [
                      Apptheme.blue,
                      Apptheme.darkred
                    ], // Gradient colors
                  ),
                  icon: Icon(null), // No icon
                ),
                SizedBox(height: 20), // Spacing between buttons

                // Sign Up Button
                GradientButton(
                  text: 'Sign Up',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SignUpScreen(), // Navigate to SignUpScreen
                      ),
                    );
                  },
                  gradient: LinearGradient(
                    colors: [
                      Apptheme.blue,
                      Apptheme.darkred
                    ], // Gradient colors
                  ),
                  icon: Icon(null), // No icon
                ),
                SizedBox(height: 20), // Spacing between buttons
              ],
            ),
          ),
        ],
      ),
    );
  }
}
