// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hawely/Features/Auth/viewmodel/auth_viewmodel.dart';
import 'package:hawely/shared/widgets/apptheme.dart';
import 'package:hawely/Features/Auth/view/components/gradient_button.dart';

class SignupForm extends StatelessWidget {
  final AuthViewModel vm;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            style: TextStyle(color: Apptheme.white),
            controller: firstNameController,
            decoration: InputDecoration(
              labelText: 'First Name',
              labelStyle: TextStyle(color: Apptheme.white, fontSize: 20),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your First Name';
              }
              return null;
            },
          ),
          TextFormField(
            style: TextStyle(color: Apptheme.white),
            controller: lastNameController,
            decoration: InputDecoration(
              labelText: 'Last Name',
              labelStyle: TextStyle(color: Apptheme.white, fontSize: 20),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Last Name';
              }

              return null;
            },
          ),
          TextFormField(
            style: TextStyle(color: Apptheme.white),
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Apptheme.white, fontSize: 20),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!vm.isValidEmail(value)) {
                // Use ViewModel's method
                return 'Only Gmail, Yahoo, Outlook, and Hotmail are allowed';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            style: TextStyle(color: Apptheme.white),
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: Apptheme.white, fontSize: 20),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          SizedBox(height: 50),
          GradientButton(
            text: 'Sign Up',
            onPressed: vm.isLoading
                ? () {}
                : () async {
                    if (formKey.currentState!.validate()) {
                      await vm.signUp(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        firstNameController.text.trim(),
                        lastNameController.text.trim(),
                      );

                      if (vm.errorMessage.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Account created successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      } else {
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
              colors: [Apptheme.blue, Apptheme.darkred],
            ),
          ),
        ],
      ),
    );
  }
}
