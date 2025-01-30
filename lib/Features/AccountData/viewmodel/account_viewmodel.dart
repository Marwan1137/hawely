// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hawely/Features/AccountData/model/user_model.dart';
import 'package:hawely/Features/Auth/viewmodel/auth_viewmodel.dart';

class AccountViewModel extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  AuthViewModel _authViewModel;
  bool _disposed = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AccountViewModel(this._authViewModel) {
    _authViewModel.addListener(_handleAuthChange);
    _loadUserData();
  }

  void _handleAuthChange() {
    if (_authViewModel.currentUser == null) {
      _user = null;
      notifyListeners();
    } else {
      _loadUserData();
    }
  }

  void updateAuthViewModel(AuthViewModel authViewModel) {
    _authViewModel = authViewModel;
    notifyListeners();
  }

  Future<void> _loadUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_authViewModel.currentUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_authViewModel.currentUser!.uid)
            .get();

        _user = UserModel.fromFirestore(userDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authViewModel.removeListener(_handleAuthChange); // Remove listener

    _disposed = true; // Mark ViewModel as disposed
    super.dispose();
  }

  void _checkIfDisposed() {
    if (_disposed) {
      throw StateError('Cannot use a disposed AccountViewModel');
    }
  }

  // void _initUser() async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     User? firebaseUser = _auth.currentUser;

  //     if (firebaseUser != null) {
  //       DocumentSnapshot userDoc =
  //           await _firestore.collection('users').doc(firebaseUser.uid).get();

  //       if (userDoc.exists) {
  //         _user =
  //             UserModel.fromFirestore(userDoc.data() as Map<String, dynamic>);
  //       } else {
  //         // Create new user document if not exists
  //         _user = UserModel(
  //           uid: firebaseUser.uid,
  //           email: firebaseUser.email,
  //         );
  //         await _firestore
  //             .collection('users')
  //             .doc(firebaseUser.uid)
  //             .set(_user!.toMap());
  //       }
  //     }
  //   } catch (e) {
  //     _error = e.toString();
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _checkIfDisposed();
    try {
      _isLoading = true;
      notifyListeners();

      User? user = _auth.currentUser;

      // Re-authenticate user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
  }) async {
    _checkIfDisposed();
    try {
      _isLoading = true;
      notifyListeners();

      // Ensure user is properly authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Prepare update data
      final updateData = <String, dynamic>{};
      if (firstName != null) updateData['firstName'] = firstName;
      if (lastName != null) updateData['lastName'] = lastName;

      // Update document using UID as document ID
      await _firestore
          .collection('users')
          .doc(user.uid) // Use auth UID as document ID
          .update(updateData);

      // Update local state
      _user = _user?.copyWith(
        firstName: firstName ?? _user?.firstName,
        lastName: lastName ?? _user?.lastName,
      );

      _error = null;
    } catch (e, stackTrace) {
      _error = 'Update failed: ${e.toString()}';
      print('Error updating profile: $e');
      print('Stack trace: $stackTrace');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _checkIfDisposed();
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }
}
