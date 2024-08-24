import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class account extends StatefulWidget {
  const account({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<account> {
  final ImagePicker _imagePicker = ImagePicker();
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Load the image URL when the screen initializes
  }

  Future<void> pickImage() async {
    try {
      XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (res != null) {
        await uploadImageToFirebase(File(res.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to pick image: $e'),
        ),
      );
    }
  }

  Future<void> uploadImageToFirebase(File image) async {
    try {
      Reference reference = FirebaseStorage.instance.ref().child(
        "images/${DateTime.now().microsecondsSinceEpoch}.png",
      );
      await reference.putFile(image);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          content: Text("Upload Successful"),
        ),
      );
      imageUrl = await reference.getDownloadURL();
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
          'imageUrl': imageUrl,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to upload image: $e'),
        ),
      );
    }
  }

  Future<void> _loadUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();

      // Set the imageUrl from Firestore into the state
      setState(() {
        imageUrl = doc['imageUrl'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 152),
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: imageUrl == null
                        ? NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png')
                        : NetworkImage(imageUrl!),
                    radius: 84,
                  ),
                  Positioned(
                    top: 125,
                    left: 138,
                    child: GestureDetector(
                      onTap: pickImage,
                      child: Icon(
                        Icons.add_a_photo,
                        color: Color.fromARGB(255, 2, 120, 205),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 32),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 74, 74, 74),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(10),
                  child: Text(
                    'Name: ${user?.displayName}',
                    style: GoogleFonts.inika(fontSize: 20, color: Colors.white),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 74, 74, 74),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(10),
                  child: Text(
                    'Email: ${user?.email}',
                    style: GoogleFonts.inika(fontSize: 20, color: Colors.white),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xff1B2020),
    );
  }
}
