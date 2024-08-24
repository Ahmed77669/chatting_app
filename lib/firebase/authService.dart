// ignore: file_names
import 'package:chating_app/screens/Welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chating_app/screens/login.dart';

class Authservice {
  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      throw Exception('Passwords do not matched.');
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
FirebaseFirestore.instance;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to log in: ${e.message}');
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<void> googleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign-in was canceled by the user.');
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await firebaseAuth.signInWithCredential(credential);

    } catch (e) {
      print('Failed to sign in with Google: $e');
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('error $e');
    }
  }
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.push(context,BottomToTopPageRoute(page:loginScreen()));
    } catch (e) {
      // Handle sign out error
      print('Error signing out: $e');
    }
  }
  User?getCurrentUser(){
    return FirebaseAuth.instance.currentUser;
  }
}
