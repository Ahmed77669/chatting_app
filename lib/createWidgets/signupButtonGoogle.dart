import 'package:chating_app/firebase/authService.dart';
import 'package:chating_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chating_app/screens/Welcome.dart';

Widget signupButtonGoogle(String text) {
  final Authservice authService = Authservice();
  return Builder(
    builder: (BuildContext context) {
      return SizedBox(
        width: 342,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            try {
              await authService.googleSignIn();
              await Navigator.push(context, BottomToTopPageRoute(page: const Home()));
            } catch (e) {
              print('error : $e');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
              side: const BorderSide(
                color: Color.fromARGB(255, 2, 120, 205),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Image(image: AssetImage('assets/google_icon.png')),
              Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 2, 120, 205),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
