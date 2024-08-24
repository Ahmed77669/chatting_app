import 'package:chating_app/firebase/authService.dart';
import 'package:chating_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/Welcome.dart';

Widget logInButton(
    String text,
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    ) {
  final Authservice authService = Authservice();

  return SizedBox(
    width: 342,
    height: 50,
    child: ElevatedButton(
      onPressed: () async {
        try {
          String email = emailController.text;
          String password = passwordController.text;

          await authService.login(
            email: email,
            password: password,
          );

          User? user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            Navigator.push(
              context,
              BottomToTopPageRoute(page: const MyHomePage()),
            );
          } else {

            throw Exception('Login failed. User not found.');
          }

        } catch (e) {
          print('Error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed. Please try again.')),
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
