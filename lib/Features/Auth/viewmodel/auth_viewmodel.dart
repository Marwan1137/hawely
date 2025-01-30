// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package for database operations
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication package
import 'package:flutter/material.dart'; // Flutter material design package
import 'package:hawely/Features/Auth/models/repsoitories/auth_repository.dart'; // Auth repository for handling auth logic
import 'package:google_sign_in/google_sign_in.dart'; // Google Sign-In package
import 'package:hawely/shared/widgets/apptheme.dart'; // App theme and colors

/* -------------------------------------------------------------------------- */
/*                          AuthViewModel Class                               */
/* -------------------------------------------------------------------------- */
class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository; // Auth repository instance
  User? _currentUser; // Current authenticated user
  DocumentSnapshot? _userData; // User data from Firestore

  User? get currentUser => _currentUser; // Getter for current user
  DocumentSnapshot? get userData => _userData; // Getter for user data

  /* -------------------------------------------------------------------------- */
  /*                              Constructor                                  */
  /* -------------------------------------------------------------------------- */
  AuthViewModel(this._authRepository) {
    // Listen to authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _currentUser = user; // Update current user
      if (user != null) {
        _loadUserData(user.uid); // Load user data if user is authenticated
      } else {
        _userData = null; // Clear user data if user is not authenticated
      }
      notifyListeners(); // Notify listeners about state changes
    });
  }

  /* -------------------------------------------------------------------------- */
  /*                          Load User Data from Firestore                    */
  /* -------------------------------------------------------------------------- */
  Future<void> _loadUserData(String uid) async {
    try {
      _userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get(); // Fetch user data from Firestore
      notifyListeners(); // Notify listeners about data changes
    } catch (e) {
      print('Error loading user data: $e'); // Log error if data loading fails
    }
  }

  bool _isLoading = false; // Loading state for async operations
  String _errorMessage = ''; // Error message for handling errors

  bool get isLoading => _isLoading; // Getter for loading state
  String get errorMessage => _errorMessage; // Getter for error message

  /* -------------------------------------------------------------------------- */
  /*                          Sign In with Email and Password                  */
  /* -------------------------------------------------------------------------- */
  Future<void> signIn(String email, String password) async {
    _isLoading = true; // Set loading state to true
    _errorMessage = ''; // Clear any previous error message
    notifyListeners(); // Notify listeners about state changes

    try {
      await _authRepository.signInWithEmailAndPassword(
          email, password); // Sign in using repository
    } on FirebaseAuthException catch (e) {
      _errorMessage =
          e.message ?? 'An error occurred'; // Handle FirebaseAuthException
    } finally {
      _isLoading = false; // Set loading state to false
      notifyListeners(); // Notify listeners about state changes
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                          Handle Email Sign-In                             */
  /* -------------------------------------------------------------------------- */
  Future<void> handleEmailSignIn(BuildContext context,
      GlobalKey<FormState> formKey, String email, String password) async {
    if (!formKey.currentState!.validate())
      return; // Validate form before proceeding

    try {
      _isLoading = true; // Set loading state to true
      notifyListeners(); // Notify listeners about state changes

      await signIn(email, password); // Sign in using email and password

      if (errorMessage.isEmpty) {
        // Show success message if no error occurred
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Logged in successfully!'),
            backgroundColor: Apptheme.green,
          ),
        );

        Navigator.pushReplacementNamed(
            context, '/home'); // Navigate to home screen
      }
    } catch (e) {
      // Show error message if sign-in fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Apptheme.red,
        ),
      );
    } finally {
      _isLoading = false; // Set loading state to false
      notifyListeners(); // Notify listeners about state changes
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                          Sign Up with Email and Password                  */
  /* -------------------------------------------------------------------------- */
  Future<void> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      _isLoading = true; // Set loading state to true
      notifyListeners(); // Notify listeners about state changes

      // Create Firebase Auth user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the new user's UID
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Save additional user data to Firestore
        await saveUserDataToFirestore(user.uid, firstName, lastName, email);
      }

      _errorMessage = ''; // Clear error message
    } on FirebaseAuthException catch (e) {
      _errorMessage =
          e.message ?? 'Signup failed'; // Handle FirebaseAuthException
    } finally {
      _isLoading = false; // Set loading state to false
      notifyListeners(); // Notify listeners about state changes
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                          Validate Email Domain                            */
  /* -------------------------------------------------------------------------- */
  bool isValidEmail(String email) {
    final allowedDomains = [
      'gmail.com',
      'yahoo.com',
      'outlook.com',
      'hotmail.com'
    ]; // List of allowed email domains
    if (!email.contains('@') || !email.contains('.')) {
      return false; // Validate email format
    }
    final domain = email.split('@')[1]; // Extract domain from email
    return allowedDomains.contains(domain); // Check if domain is allowed
  }

  /* -------------------------------------------------------------------------- */
  /*                          Sign In with Google                              */
  /* -------------------------------------------------------------------------- */
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        // Get Google authentication details
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create Firebase credentials
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with Google credentials
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Get user details
        final User? user = userCredential.user;
        if (user != null) {
          // Extract first and last name from Google profile
          final String firstName =
              googleUser.displayName?.split(' ').first ?? '';
          final String lastName = googleUser.displayName?.split(' ').last ?? '';
          final String email = googleUser.email;

          // Save user data to Firestore
          await saveUserDataToFirestore(user.uid, firstName, lastName, email);
          Navigator.of(context)
              .pushReplacementNamed('/home'); // Navigate to home screen
        }
      }
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged in successfully!'),
          backgroundColor: Apptheme.green,
        ),
      );
    } catch (e) {
      // Show error message if Google Sign-In fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error in login: $e'),
          backgroundColor: Apptheme.green,
        ),
      );
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                          Save User Data to Firestore                      */
  /* -------------------------------------------------------------------------- */
  Future<void> saveUserDataToFirestore(
    String userId,
    String firstName,
    String lastName,
    String email,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(), // Add timestamp
      });
      print('User data saved to Firestore successfully!'); // Log success
    } catch (e) {
      print('Firestore error: $e'); // Log error if Firestore operation fails
    }
  }
}
