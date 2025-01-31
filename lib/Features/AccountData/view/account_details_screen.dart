// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:hawely/Features/AccountData/viewmodel/account_viewmodel.dart'; // Account viewmodel for state management
import 'package:hawely/Features/Auth/viewmodel/auth_viewmodel.dart'; // Auth viewmodel for authentication state
import 'package:hawely/shared/widgets/apptheme.dart'; // App theme and colors
import 'package:hawely/shared/widgets/custom_appbar.dart'; // Custom app bar widget
import 'package:hawely/shared/widgets/custom_bottom_appbar.dart'; // Custom bottom app bar widget
import 'package:provider/provider.dart'; // Provider package for state management

/* -------------------------------------------------------------------------- */
/*                          AccountDetailsScreen Widget                       */
/* -------------------------------------------------------------------------- */
class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  late AccountViewModel _viewModel; // Account viewmodel instance

  @override
  void initState() {
    super.initState();
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    _viewModel =
        AccountViewModel(authVM); // Initialize viewmodel with auth viewmodel
  }

  @override
  void dispose() {
    _viewModel.dispose(); // Dispose viewmodel resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Hawely', // First title
        title2: 'Account Details', // Second title
        colors: [Apptheme.blue, Apptheme.darkred],
        automaticallyImplyLeading: false, // Gradient colors
      ),
      bottomNavigationBar: const CustomBottomAppbar(), // Custom bottom app bar
      body: Consumer<AccountViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(
                child: CircularProgressIndicator()); // Show loading indicator
          }

          if (viewModel.user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please sign in to view account details', // Prompt to sign in
                    style: TextStyle(fontSize: 18, color: Apptheme.black),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to login screen
                    },
                    child: const Text('Sign In'), // Sign-in button
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildUserInfoTile(
                  title: 'First Name', // First name field
                  value: viewModel.user!.firstName ??
                      'Not set', // First name value
                  onEdit: () => _showEditDialog(context,
                      isFirstName: true), // Edit callback
                ),
                _buildUserInfoTile(
                  title: 'Last Name', // Last name field
                  value:
                      viewModel.user!.lastName ?? 'Not set', // Last name value
                  onEdit: () => _showEditDialog(context,
                      isFirstName: false), // Edit callback
                ),
                _buildUserInfoTile(
                  title: 'Email', // Email field
                  value: viewModel.user!.email!, // Email value
                ),
                const SizedBox(height: 24),
                _buildChangePasswordButton(context), // Change password button
                const SizedBox(height: 24),
                _buildSignOutButton(context), // Sign-out button
              ],
            ),
          );
        },
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                          Build User Info Tile                             */
  /* -------------------------------------------------------------------------- */
  Widget _buildUserInfoTile({
    required String title, // Field title
    required String value, // Field value
    VoidCallback? onEdit, // Optional edit callback
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Apptheme.blue), // Title text style
      ),
      subtitle: Text(
        value,
        style: TextStyle(color: Apptheme.white), // Value text style
      ),
      trailing: onEdit != null
          ? IconButton(
              icon: Icon(Icons.edit, color: Apptheme.blue), // Edit icon
              onPressed: onEdit, // Edit callback
            )
          : null,
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                          Build Change Password Button                      */
  /* -------------------------------------------------------------------------- */
  Widget _buildChangePasswordButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Apptheme.blue, // Button background color
        padding: const EdgeInsets.symmetric(vertical: 16), // Button padding
      ),
      onPressed: () =>
          _showChangePasswordDialog(context), // Show change password dialog
      child: const Text(
        'Change Password', // Button text
        style:
            TextStyle(fontSize: 16, color: Apptheme.white), // Button text style
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                          Build Sign Out Button                             */
  /* -------------------------------------------------------------------------- */
  Widget _buildSignOutButton(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Apptheme.darkred), // Button border color
        padding: const EdgeInsets.symmetric(vertical: 16), // Button padding
      ),
      onPressed: () async {
        try {
          final viewModel =
              Provider.of<AccountViewModel>(context, listen: false);

          // Check if the widget is still mounted before proceeding
          if (!mounted) return;

          await viewModel.signOut(); // Sign out user

          // Check again if the widget is still mounted before navigating
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (route) => false, // Navigate to home screen
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Sign out failed: ${e.toString()}')), // Show error message
            );
          }
        }
      },
      child: const Text(
        'Sign Out', // Button text
        style: TextStyle(
            fontSize: 16, color: Apptheme.darkred), // Button text style
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                          Show Edit Dialog                                 */
  /* -------------------------------------------------------------------------- */
  void _showEditDialog(BuildContext context, {required bool isFirstName}) {
    final viewModel = Provider.of<AccountViewModel>(context, listen: false);
    final controller = TextEditingController(); // Controller for text input

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit ${isFirstName ? 'First Name' : 'Last Name'}', // Dialog title
          style: TextStyle(color: Apptheme.black), // Title text style
        ),
        content: TextField(
          controller: controller, // Text input controller
          decoration: InputDecoration(
            hintText:
                'Enter new ${isFirstName ? 'first name' : 'last name'}', // Hint text
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel button
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              print('Save button pressed');
              if (controller.text.isNotEmpty) {
                if (isFirstName) {
                  await viewModel.updateProfile(
                      firstName: controller.text); // Update first name
                } else {
                  await viewModel.updateProfile(
                      lastName: controller.text); // Update last name
                }
                Navigator.pop(context); // Close dialog
              }
            },
            child: const Text('Save'), // Save button
          ),
        ],
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                          Show Change Password Dialog                       */
  /* -------------------------------------------------------------------------- */
  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController =
        TextEditingController(); // Controller for current password
    final newPasswordController =
        TextEditingController(); // Controller for new password

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'), // Dialog title
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true, // Hide current password
              decoration: const InputDecoration(
                labelText: 'Current Password', // Label for current password
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true, // Hide new password
              decoration: const InputDecoration(
                labelText: 'New Password', // Label for new password
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel button
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<AccountViewModel>().updatePassword(
                    currentPassword:
                        currentPasswordController.text, // Current password
                    newPassword: newPasswordController.text, // New password
                  );
              Navigator.pop(context); // Close dialog
            },
            child: const Text('Change Password'), // Change password button
          ),
        ],
      ),
    );
  }
}
