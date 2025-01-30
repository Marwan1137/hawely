// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:hawely/Features/AccountData/viewmodel/account_viewmodel.dart';
import 'package:hawely/Features/Auth/viewmodel/auth_viewmodel.dart';
import 'package:hawely/shared/widgets/apptheme.dart';
import 'package:hawely/shared/widgets/custom_appbar.dart';
import 'package:hawely/shared/widgets/custom_bottom_appbar.dart';
import 'package:provider/provider.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  late AccountViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    _viewModel = AccountViewModel(authVM);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Hawely',
        title2: 'Account Details',
        colors: [Apptheme.blue, Apptheme.darkred],
      ),
      bottomNavigationBar: CustomBottomAppbar(),
      body: Consumer<AccountViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please sign in to view account details',
                    style: TextStyle(fontSize: 18, color: Apptheme.black),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to login screen
                    },
                    child: const Text('Sign In'),
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
                  title: 'First Name',
                  value: viewModel.user!.firstName ?? 'Not set',
                  onEdit: () => _showEditDialog(context, isFirstName: true),
                ),
                _buildUserInfoTile(
                  title: 'Last Name',
                  value: viewModel.user!.lastName ?? 'Not set',
                  onEdit: () => _showEditDialog(context, isFirstName: false),
                ),
                _buildUserInfoTile(
                  title: 'Email',
                  value: viewModel.user!.email!,
                ),
                const SizedBox(height: 24),
                _buildChangePasswordButton(context),
                const SizedBox(height: 24),
                _buildSignOutButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfoTile({
    required String title,
    required String value,
    VoidCallback? onEdit,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Apptheme.blue),
      ),
      subtitle: Text(
        value,
        style: TextStyle(color: Apptheme.white),
      ),
      trailing: onEdit != null
          ? IconButton(
              icon: Icon(Icons.edit, color: Apptheme.blue),
              onPressed: onEdit,
            )
          : null,
    );
  }

  Widget _buildChangePasswordButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Apptheme.blue,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () => _showChangePasswordDialog(context),
      child: const Text(
        'Change Password',
        style: TextStyle(fontSize: 16, color: Apptheme.white),
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Apptheme.darkred),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () async {
        try {
          final viewModel =
              Provider.of<AccountViewModel>(context, listen: false);

          // Check if the widget is still mounted before proceeding
          if (!mounted) return;

          await viewModel.signOut();

          // Check again if the widget is still mounted before navigating
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (route) => false,
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sign out failed: ${e.toString()}')),
            );
          }
        }
      },
      child: const Text(
        'Sign Out',
        style: TextStyle(fontSize: 16, color: Apptheme.darkred),
      ),
    );
  }

  void _showEditDialog(BuildContext context, {required bool isFirstName}) {
    final viewModel = Provider.of<AccountViewModel>(context, listen: false);

    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit ${isFirstName ? 'First Name' : 'Last Name'}',
          style: TextStyle(color: Apptheme.black),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter new ${isFirstName ? 'first name' : 'last name'}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              print('Save button pressed');
              if (controller.text.isNotEmpty) {
                if (isFirstName) {
                  await viewModel.updateProfile(firstName: controller.text);
                } else {
                  await viewModel.updateProfile(lastName: controller.text);
                }
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<AccountViewModel>().updatePassword(
                    currentPassword: currentPasswordController.text,
                    newPassword: newPasswordController.text,
                  );
              Navigator.pop(context);
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }
}
