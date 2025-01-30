// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:hawely/Features/Auth/view/sign_in_screen.dart';
import 'package:hawely/Features/Auth/view/sign_up_screen.dart';
import 'package:hawely/shared/widgets/apptheme.dart';
import 'package:hawely/shared/widgets/custom_appbar.dart';
import 'package:hawely/Features/Auth/view/components/gradient_button.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final List<String> images = [
    'assets/currencyconverter1.jpg',
    'assets/currencyconverter3.png',
    'assets/currencyconverter2.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Swiper with rounded bottom edges
          Positioned(
            top: 0, // Start from the top of the screen
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                  );
                },
                itemCount: images.length,
                autoplay: true, // Automatically transition between images
                duration: 1000, // Transition duration in milliseconds
                autoplayDelay: 3000, // Delay between transitions
              ),
            ),
          ),

          // Shaded overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6), // Dark overlay
                    Colors.black.withOpacity(0.3), // Lighter overlay
                  ],
                ),
              ),
            ),
          ),

          // AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomAppBar(
              title1: 'Welcome to Hawely',
              title2: 'Currency Converter',
              colors: [Apptheme.blue, Apptheme.darkred],
            ),
          ),

          // Buttons
          Positioned(
            bottom: 70,
            left: 50,
            right: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradientButton(
                  text: 'Sign In',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(),
                      ),
                    );
                  },
                  gradient: LinearGradient(
                    colors: [Apptheme.blue, Apptheme.darkred],
                  ),
                  icon: Icon(null),
                ),
                SizedBox(height: 20),
                GradientButton(
                  text: 'Sign Up',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ),
                    );
                  },
                  gradient: LinearGradient(
                    colors: [Apptheme.blue, Apptheme.darkred],
                  ),
                  icon: Icon(null),
                ),
                SizedBox(height: 20),
                GradientButton(
                  text: 'Continue as guest',
                  onPressed: () {},
                  gradient: LinearGradient(
                    colors: [Apptheme.blue, Apptheme.darkred],
                  ),
                  icon: Icon(null),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
