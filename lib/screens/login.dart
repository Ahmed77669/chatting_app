import 'package:chating_app/createWidgets/logInButton.dart';
import 'package:chating_app/screens/Welcome.dart';
import 'package:chating_app/screens/resetPassword.dart';
import 'package:chating_app/screens/signup.dart';
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
      home: loginScreen(),
    );
  }

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<loginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 168),
              const Icon(Icons.message,size: 80,color: Color.fromARGB(
                  255, 81, 81, 81),),
              const SizedBox(
                height: 92,
              ),
              createTextField('Email', false, _emailController),
              const SizedBox(
                height: 28,
              ),
              createTextField('Password', true, _passwordController),
              const SizedBox(
                height: 12,
              ),
              Row(children: [
                const SizedBox(
                  width: 52,
                ),
                Text(
                  'forget your password?',
                  style: GoogleFonts.inter(color: Colors.black),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, BottomToTopPageRoute(page: const resetPassword()));
                  },
                  child: Text(
                    'Click Here ',
                    style: GoogleFonts.inter(
                        // fontSize: 16,
                        color: Colors.blue),
                  ),
                )
              ]),
              const SizedBox(
                height: 60,
              ),
              logInButton('Log in', context,  _emailController,
                  _passwordController),
              const SizedBox(
                height: 25,
              ),
              // Text(
              //   'or',
              //   style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
              // ),
              const SizedBox(
                height: 25,
              ),
              // signupButtonGoogle('Log in with google'),
              const SizedBox(
                height: 86,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context, BottomToTopPageRoute(page: const signup()));
                    },
                    child: Text(
                      'SignUp ',
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 0, 117, 255)),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }
}
