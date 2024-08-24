import 'package:chating_app/firebase/authService.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chating_app/screens/Welcome.dart';

import '../screens/login.dart';

Widget resetPasswordButton(
  context,
  TextEditingController emailController,
) {
  final Authservice authService = Authservice();

  return SizedBox(
    width: 320,
    height: 50,
    child: ElevatedButton(
      onPressed: () async {
        try {
          String email = emailController.text.trim();
          await authService.resetPassword(email: emailController.text.trim());
          if (emailController.text.trim() != '') {
            Navigator.push(context, BottomToTopPageRoute(page: const loginScreen()));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Check your mail link sent')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter your mail')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 2, 120, 205),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      child: Text(
        'Reset Password',
        style: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ),
  );
}
