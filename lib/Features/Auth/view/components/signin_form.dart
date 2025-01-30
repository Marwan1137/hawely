import 'package:flutter/material.dart';
import 'package:hawely/Features/Auth/viewmodel/auth_viewmodel.dart';
import 'package:hawely/shared/widgets/apptheme.dart';
import 'package:hawely/Features/Auth/view/components/gradient_button.dart';

class SignInForm extends StatelessWidget {
  final AuthViewModel vm;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
            text: 'Sign In',
            onPressed: vm.isLoading
                ? () {}
                : () async {
                    vm.handleEmailSignIn(
                      context,
                      formKey,
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                  },
            gradient: const LinearGradient(
              colors: [Apptheme.blue, Apptheme.darkred],
            ),
          ),
          SizedBox(height: 50),
          GradientButton(
            text: 'Sign In with Google',
            onPressed: vm.isLoading
                ? () {}
                : () async {
                    vm.signInWithGoogle(context);
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
