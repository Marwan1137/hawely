// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication package
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package for database operations
import 'package:google_sign_in/google_sign_in.dart'; // Google Sign-In package
import 'package:hawely/Features/AccountData/model/user_model.dart'; // User model for data representation
import 'package:hawely/Features/Auth/viewmodel/auth_viewmodel.dart'; // Auth viewmodel for authentication state

/* -------------------------------------------------------------------------- */
/*                          AccountViewModel Class                            */
/* -------------------------------------------------------------------------- */
class AccountViewModel extends ChangeNotifier {
  UserModel? _user; // Current user data
  bool _isLoading = false; // Loading state for async operations
  String? _error; // Error message for handling errors
  AuthViewModel _authViewModel; // Auth viewmodel instance
  bool _disposed = false; // Flag to check if ViewModel is disposed

  UserModel? get user => _user; // Getter for user data
  bool get isLoading => _isLoading; // Getter for loading state
  String? get error => _error; // Getter for error message

  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance

  /* -------------------------------------------------------------------------- */
  /*                              Constructor                                  */
/* -------------------------------------------------------------------------- */
  AccountViewModel(this._authViewModel) {
    _authViewModel
        .addListener(_handleAuthChange); // Listen to auth state changes
    _loadUserData(); // Load user data on initialization
  }

  /* -------------------------------------------------------------------------- */
  /*                          Handle Authentication Changes                    */
  /* -------------------------------------------------------------------------- */
  void _handleAuthChange() {
    if (_authViewModel.currentUser == null) {
      _user = null; // Clear user data if not authenticated
      notifyListeners(); // Notify listeners about state changes
    } else {
      _loadUserData(); // Load user data if authenticated
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                          Update Auth ViewModel                            */
  /* -------------------------------------------------------------------------- */
  void updateAuthViewModel(AuthViewModel authViewModel) {
    _authViewModel = authViewModel; // Update auth viewmodel
    notifyListeners(); // Notify listeners about state changes
  }

  /* -------------------------------------------------------------------------- */
  /*                          Load User Data from Firestore                    */
  /* -------------------------------------------------------------------------- */
  Future<void> _loadUserData() async {
    _isLoading = true; // Set loading state to true
    notifyListeners(); // Notify listeners about state changes

    try {
      if (_authViewModel.currentUser != null) {
        // Fetch user data from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_authViewModel.currentUser!.uid)
            .get();

        // Parse user data into UserModel
        _user = UserModel.fromFirestore(userDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      _error = e.toString(); // Handle errors
    } finally {
      _isLoading = false; // Set loading state to false
      notifyListeners(); // Notify listeners about state changes
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                              Cleanup                                      */
  /* -------------------------------------------------------------------------- */
  @override
  void dispose() {
    _authViewModel
        .removeListener(_handleAuthChange); // Remove auth state listener
    _disposed = true; // Mark ViewModel as disposed
    super.dispose();
  }

  /* -------------------------------------------------------------------------- */
  /*                          Check if ViewModel is Disposed                   */
  /* -------------------------------------------------------------------------- */
  void _checkIfDisposed() {
    if (_disposed) {
      throw StateError(
          'Cannot use a disposed AccountViewModel'); // Throw error if disposed
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                          Update User Password                             */
  /* -------------------------------------------------------------------------- */
  Future<void> updatePassword({
    required String currentPassword, // Current password
    required String newPassword, // New password
  }) async {
    _checkIfDisposed(); // Check if ViewModel is disposed
    try {
      _isLoading = true; // Set loading state to true
      notifyListeners(); // Notify listeners about state changes

      User? user = _auth.currentUser;

      // Re-authenticate user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!, // User's email
        password: currentPassword, // Current password
      );

      await user.reauthenticateWithCredential(credential); // Re-authenticate
      await user.updatePassword(newPassword); // Update password

      _error = null; // Clear error message
    } catch (e) {
      _error = e.toString(); // Handle errors
    } finally {
      _isLoading = false; // Set loading state to false
      notifyListeners(); // Notify listeners about state changes
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                          Update User Profile                              */
  /* -------------------------------------------------------------------------- */
  Future<void> updateProfile({
    String? firstName, // New first name
    String? lastName, // New last name
  }) async {
    _checkIfDisposed(); // Check if ViewModel is disposed
    try {
      _isLoading = true; // Set loading state to true
      notifyListeners(); // Notify listeners about state changes

      // Ensure user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception(
            'User not authenticated'); // Throw error if not authenticated
      }

      // Prepare update data
      final updateData = <String, dynamic>{};
      if (firstName != null)
        updateData['firstName'] = firstName; // Add first name
      if (lastName != null) updateData['lastName'] = lastName; // Add last name

      // Update Firestore document
      await _firestore
          .collection('users')
          .doc(user.uid) // Use UID as document ID
          .update(updateData);

      // Update local user data
      _user = _user?.copyWith(
        firstName: firstName ?? _user?.firstName, // Update first name
        lastName: lastName ?? _user?.lastName, // Update last name
      );

      _error = null; // Clear error message
    } catch (e, stackTrace) {
      _error = 'Update failed: ${e.toString()}'; // Handle errors
      print('Error updating profile: $e'); // Log error
      print('Stack trace: $stackTrace'); // Log stack trace
    } finally {
      _isLoading = false; // Set loading state to false
      notifyListeners(); // Notify listeners about state changes
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                          Sign Out User                                    */
  /* -------------------------------------------------------------------------- */
  Future<void> signOut() async {
    _checkIfDisposed(); // Check if ViewModel is disposed
    try {
      await _auth.signOut(); // Sign out from Firebase Auth
      await GoogleSignIn().signOut(); // Sign out from Google Sign-In
      _user = null; // Clear user data
      notifyListeners(); // Notify listeners about state changes
    } catch (e) {
      print('Sign out error: $e'); // Log error
      rethrow; // Re-throw the error
    }
  }
}
