// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hawely/Features/Auth/models/repsoitories/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hawely/shared/widgets/apptheme.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  User? _currentUser;
  DocumentSnapshot? _userData;

  User? get currentUser => _currentUser;
  DocumentSnapshot? get userData => _userData;

  AuthViewModel(this._authRepository) {
    // Add auth state listener
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _currentUser = user;
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        _userData = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserData(String uid) async {
    try {
      _userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      notifyListeners();
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _authRepository.signInWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'An error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleEmailSignIn(BuildContext context,
      GlobalKey<FormState> formKey, String email, String password) async {
    if (!formKey.currentState!.validate()) return;

    try {
      _isLoading = true;
      notifyListeners();

      await signIn(email, password);

      if (errorMessage.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Logged in successfully!'),
            backgroundColor: Apptheme.green,
          ),
        );

        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Apptheme.red,
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

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

      _errorMessage = '';
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Signup failed';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isValidEmail(String email) {
    final allowedDomains = [
      'gmail.com',
      'yahoo.com',
      'outlook.com',
      'hotmail.com'
    ];
    if (!email.contains('@') || !email.contains('.')) {
      return false;
    }
    final domain = email.split('@')[1];
    return allowedDomains.contains(domain);
  }

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
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged in successfully!'),
          backgroundColor: Apptheme.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error in login: $e'),
          backgroundColor: Apptheme.green,
        ),
      );
    }
  }

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
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('User data saved to Firestore successfully!');
    } catch (e) {
      print('Firestore error: $e');
    }
  }
}
