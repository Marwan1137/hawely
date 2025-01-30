// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:hawely/Features/Auth/view/components/auth_background.dart';
import 'package:hawely/Features/Auth/view/components/signin_form.dart';
import 'package:hawely/Features/Auth/viewmodel/auth_viewmodel.dart';
import 'package:hawely/shared/widgets/apptheme.dart';
import 'package:hawely/shared/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const AuthBackground(images: [
            'assets/currencyconverter1.jpg',
            'assets/currencyconverter3.png',
            'assets/currencyconverter2.png',
          ]),

          // AppBar
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomAppBar(
              title1: 'Hawely',
              title2: 'Currency Converter',
              colors: [Apptheme.blue, Apptheme.darkred],
            ),
          ),

          // Form positioned in the center
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 16,
            right: 16,
            child: Form(
              key: _formKey,
              child: SignInForm(
                vm: viewModel,
                emailController: _emailController,
                passwordController: _passwordController,
                formKey: _formKey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
