// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart'; // Swiper package for image carousel

/* -------------------------------------------------------------------------- */
/*                          AuthBackground Widget                            */
/* -------------------------------------------------------------------------- */
class AuthBackground extends StatelessWidget {
  final List<String> images; // List of image paths for the swiper

  const AuthBackground({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
      ],
    );
  }
}
