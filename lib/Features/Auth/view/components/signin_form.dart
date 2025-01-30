import 'package:flutter/material.dart'; // Flutter UI components
import 'package:hawely/Features/Auth/viewmodel/auth_viewmodel.dart'; // Auth viewmodel
import 'package:hawely/shared/widgets/apptheme.dart'; // Theme
import 'package:hawely/Features/Auth/view/components/gradient_button.dart'; // Gradient button widget

/* -------------------------------------------------------------------------- */
/*                             SignInForm Widget                              */
/* -------------------------------------------------------------------------- */
class SignInForm extends StatelessWidget {
  final AuthViewModel vm; // ViewModel instance
  final TextEditingController emailController; // Controller for email input
  final TextEditingController
      passwordController; // Controller for password input
  final GlobalKey<FormState> formKey; // Form key for validation

  const SignInForm({
    super.key,
    required this.vm,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the children
        children: [
          /* --------------------------- Email Input Field --------------------------- */
          TextFormField(
            style: TextStyle(color: Apptheme.white), // Input text color
            controller: emailController, // Controller
            decoration: InputDecoration(
              labelText: 'Email', // Label for email field
              labelStyle: TextStyle(color: Apptheme.white, fontSize: 20),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email'; // Validation message
              }
              if (!vm.isValidEmail(value)) {
                // Validate email using ViewModel method
                return 'Only Gmail, Yahoo, Outlook, and Hotmail are allowed';
              }
              return null; // Validation passed
            },
          ),
          SizedBox(height: 16), // Spacer

          /* ------------------------- Password Input Field ------------------------- */
          TextFormField(
            style: TextStyle(color: Apptheme.white), // Input text color
            controller: passwordController, // Controller
            decoration: InputDecoration(
              labelText: 'Password', // Label for password field
              labelStyle: TextStyle(color: Apptheme.white, fontSize: 20),
            ),
            obscureText: true, // Hide password input
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password'; // Validation message
              }
              return null; // Validation passed
            },
          ),
          SizedBox(height: 50), // Spacer

          /* ---------------------------- Sign In Button ---------------------------- */
          GradientButton(
            text: 'Sign In', // Button text
            onPressed: vm.isLoading // Check loading state
                ? () {} // Disable button if loading
                : () async {
                    vm.handleEmailSignIn(
                      context,
                      formKey, // Validate form
                      emailController.text.trim(), // Trim email input
                      passwordController.text.trim(), // Trim password input
                    );
                  },
            gradient: const LinearGradient(
              colors: [Apptheme.blue, Apptheme.darkred], // Gradient colors
            ),
          ),
          SizedBox(height: 50), // Spacer

          /* ----------------------- Sign In with Google Button ---------------------- */
          GradientButton(
            text: 'Sign In with Google', // Button text
            onPressed: vm.isLoading // Check loading state
                ? () {} // Disable button if loading
                : () async {
                    vm.signInWithGoogle(context); // Google sign-in method
                  },
            gradient: const LinearGradient(
              colors: [Apptheme.blue, Apptheme.darkred], // Gradient colors
            ),
          ),
        ],
      ),
    );
  }
}
