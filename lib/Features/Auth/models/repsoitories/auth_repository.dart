/* -------------------------------------------------------------------------- */
/*                          AuthRepository Class                              */
/* -------------------------------------------------------------------------- */
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication package

class AuthRepository {
  final FirebaseAuth _firebaseAuth; // FirebaseAuth instance for authentication

  /* -------------------------------------------------------------------------- */
  /*                              Constructor                                  */
  /* -------------------------------------------------------------------------- */
  AuthRepository(this._firebaseAuth); // Initialize with a FirebaseAuth instance

  /* -------------------------------------------------------------------------- */
  /*                      Sign In with Email and Password                      */
  /* -------------------------------------------------------------------------- */
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email, // User's email
      password: password, // User's password
    ); // Sign in using FirebaseAuth
  }

  /* -------------------------------------------------------------------------- */
  /*                      Sign Up with Email and Password                      */
  /* -------------------------------------------------------------------------- */
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, // User's email
      password: password, // User's password
    ); // Create a new user using FirebaseAuth
  }
}
