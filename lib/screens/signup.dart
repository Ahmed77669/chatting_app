import 'package:chating_app/createWidgets/signUpButton.dart';
import 'package:chating_app/screens/Welcome.dart';
import 'package:chating_app/screens/login.dart';
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
      home: signup(),
    );
  }

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<signup> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
              const SizedBox(height: 152),
              const Icon(Icons.message,size: 80,color: Color.fromARGB(
                  255, 81, 81, 81),),
              const SizedBox(
                height: 92,
              ),
              createTextField('Name', false, _name),
              const SizedBox(
                height: 28,
              ),
              createTextField('Email', false, _emailController),
              const SizedBox(
                height: 28,
              ),
              createTextField('Password', true, _passwordController),
              const SizedBox(
                height: 28,
              ),
              createTextField(
                  'Confirm Password', true, _confirmPasswordController),
              const SizedBox(
                height: 28,
              ),
              const SizedBox(
                height: 30,
              ),
              signupButton('Sign Up', context, _name, _emailController,
                  _passwordController, _confirmPasswordController),
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
                    "Have already an account? ",
                    style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context, BottomToTopPageRoute(page: const loginScreen()));
                    },
                    child: Text(
                      'Log in ',
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
