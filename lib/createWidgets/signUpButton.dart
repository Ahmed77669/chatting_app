import 'package:chating_app/screens/Welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chating_app/firebase/authService.dart';
import 'package:chating_app/screens/login.dart';

Widget signupButton(
    String text,
    BuildContext context,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
    ) {
  final Authservice authService = Authservice();

  return SizedBox(
    width: 342,
    height: 50,
    child: ElevatedButton(
      onPressed: () async {
        try {
          String name = nameController.text;
          String email = emailController.text;
          String password = passwordController.text;
          String confirmPassword = confirmPasswordController.text;

          print('Name: $name');
          print('Email: $email');
          print('Password: $password');
          print('Confirm Password: $confirmPassword');

          await authService.signup(
            name: name,
            email: email,
            password: password,
            confirmPassword: confirmPassword,
          );

          User? user = FirebaseAuth.instance.currentUser;

          await user?.updateDisplayName(name);

          await user?.reload();

          user = FirebaseAuth.instance.currentUser;
          print("=======================> ${user?.displayName}");

          await FirebaseFirestore.instance.collection("Users").doc(user!.uid).set({
            'uid': user.uid,
            'name': user.displayName,
            'email': user.email,
          });

          Navigator.push(
            context,
            BottomToTopPageRoute(page: const loginScreen()),
          );

        } catch (e) {
          print('Error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign-up failed. Please try again.')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 81, 81, 81),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ),
  );
}
