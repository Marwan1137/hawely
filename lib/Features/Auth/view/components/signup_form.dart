// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart'; // Flutter UI components
import 'package:hawely/Features/Auth/viewmodel/auth_viewmodel.dart'; // Auth ViewModel
import 'package:hawely/shared/widgets/apptheme.dart'; // Theme
import 'package:hawely/Features/Auth/view/components/gradient_button.dart'; // Gradient button widget

/* -------------------------------------------------------------------------- */
/*                            SignupForm Widget                              */
/* -------------------------------------------------------------------------- */
class SignupForm extends StatelessWidget {
  final AuthViewModel vm; // ViewModel instance
  final TextEditingController emailController; // Controller for email input
  final TextEditingController
      passwordController; // Controller for password input
  final GlobalKey<FormState> formKey; // Form key for validation
  final TextEditingController
      firstNameController; // Controller for first name input
  final TextEditingController
      lastNameController; // Controller for last name input

  const SignupForm({
    super.key,
    required this.vm,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the children
        children: [
          /* ------------------------ First Name Input Field ------------------------ */
          TextFormField(
            style: TextStyle(color: Apptheme.white), // Input text color
            controller: firstNameController, // Controller
            decoration: InputDecoration(
              labelText: 'First Name', // Label for first name field
              labelStyle: TextStyle(color: Apptheme.white, fontSize: 20),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your First Name'; // Validation message
              }
              return null; // Validation passed
            },
          ),

          /* ------------------------- Last Name Input Field ------------------------- */
          TextFormField(
            style: TextStyle(color: Apptheme.white), // Input text color
            controller: lastNameController, // Controller
            decoration: InputDecoration(
              labelText: 'Last Name', // Label for last name field
              labelStyle: TextStyle(color: Apptheme.white, fontSize: 20),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Last Name'; // Validation message
              }
              return null; // Validation passed
            },
          ),

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

          /* ----------------------------- Sign Up Button ---------------------------- */
          GradientButton(
            text: 'Sign Up', // Button text
            onPressed: vm.isLoading // Check loading state
                ? () {} // Disable button if loading
                : () async {
                    if (formKey.currentState!.validate()) {
                      await vm.signUp(
                        emailController.text.trim(), // Email input
                        passwordController.text.trim(), // Password input
                        firstNameController.text.trim(), // First name input
                        lastNameController.text.trim(), // Last name input
                      );

                      if (vm.errorMessage.isEmpty) {
                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Account created successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context); // Navigate back
                      } else {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(vm.errorMessage),
                            backgroundColor: Apptheme.red,
                          ),
                        );
                      }
                    }
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
