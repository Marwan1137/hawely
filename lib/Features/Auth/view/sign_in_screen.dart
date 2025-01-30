// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:hawely/Features/Auth/view/components/auth_background.dart'; // Background widget for auth screens
import 'package:hawely/Features/Auth/view/components/signin_form.dart'; // Sign-in form widget
import 'package:hawely/Features/Auth/viewmodel/auth_viewmodel.dart'; // Auth viewmodel for state management
import 'package:hawely/shared/widgets/apptheme.dart'; // App theme and colors
import 'package:hawely/shared/widgets/custom_appbar.dart'; // Custom app bar widget
import 'package:provider/provider.dart'; // Provider package for state management

/* -------------------------------------------------------------------------- */
/*                            SignInScreen Widget                            */
/* -------------------------------------------------------------------------- */
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final _emailController =
      TextEditingController(); // Controller for email input
  final _passwordController =
      TextEditingController(); // Controller for password input

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<AuthViewModel>(context); // Access AuthViewModel

    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent background
      body: Stack(
        children: [
          /* ------------------------------------------------------------------ */
          /*                          Auth Background                           */
          /* ------------------------------------------------------------------ */
          const AuthBackground(images: [
            'assets/currencyconverter1.jpg', // Image 1 for background
            'assets/currencyconverter3.png', // Image 2 for background
            'assets/currencyconverter2.png', // Image 3 for background
          ]),

          /* ------------------------------------------------------------------ */
          /*                              AppBar                                */
          /* ------------------------------------------------------------------ */
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomAppBar(
              title1: 'Hawely', // First title
              title2: 'Currency Converter', // Second title
              colors: [Apptheme.blue, Apptheme.darkred], // Gradient colors
            ),
          ),

          /* ------------------------------------------------------------------ */
          /*                              Sign-In Form                          */
          /* ------------------------------------------------------------------ */
          Positioned(
            top: MediaQuery.of(context).size.height *
                0.35, // Position form at 35% of screen height
            left: 16,
            right: 16,
            child: Form(
              key: _formKey, // Form key for validation
              child: SignInForm(
                vm: viewModel, // Pass AuthViewModel to the form
                emailController: _emailController, // Pass email controller
                passwordController:
                    _passwordController, // Pass password controller
                formKey: _formKey, // Pass form key
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                              Cleanup                                      */
  /* -------------------------------------------------------------------------- */
  @override
  void dispose() {
    _emailController.dispose(); // Dispose email controller
    _passwordController.dispose(); // Dispose password controller
    super.dispose();
  }
}
