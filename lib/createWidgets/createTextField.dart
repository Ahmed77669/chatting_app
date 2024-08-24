import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget createTextField(
    String text, bool hide, TextEditingController controller) {
  return SizedBox(
    width: 340,
    child: TextField(
      controller: controller,
      obscureText: hide,
      decoration: InputDecoration(
        labelText: text,
        labelStyle: GoogleFonts.roboto(
            color: const Color.fromARGB(255, 74, 74, 74), fontSize: 16),
        filled: true,
        fillColor: const Color.fromARGB(255, 229, 229, 234),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      style:
          const TextStyle(color: Color.fromARGB(255, 74, 74, 74), fontSize: 16),
    ),
  );
}
