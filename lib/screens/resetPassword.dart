import 'package:chating_app/createWidgets/resetPasswordButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chating_app/createWidgets/createTextField.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: resetPassword(),
    );
  }

  @override

  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}

class resetPassword extends StatefulWidget {
  const resetPassword({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<resetPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 152),

              const Icon(Icons.message,size: 80,color: Color.fromARGB(
                  255, 81, 81, 81),),
              const SizedBox(
                height: 82,
              ),
              Text(
                'Reset Password',
                style: GoogleFonts.inika(fontSize: 30),
              ),
              const SizedBox(
                height: 28,
              ),
              createTextField('Email', false, _emailController),
              const SizedBox(
                height: 60,
              ),
              resetPasswordButton(context, _emailController),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
    );
  }
}
