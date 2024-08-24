import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../chat_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Chats(
        receiverID: 'receiverID',
        name: 'Chat',
        photoUrl: "https://www.photo.com",
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class Chats extends StatefulWidget {
  final String receiverID;
  final String name;
  final String photoUrl;

  const Chats({
    required this.receiverID,
    required this.name,
    required this.photoUrl,
    super.key,
  });

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final TextEditingController messageController = TextEditingController();
  final chat_service chatService = chat_service();
  final ImagePicker _imagePicker = ImagePicker();

  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    senderId = FirebaseAuth.instance.currentUser?.uid;

    myFocusNode.addListener(() {
       if(myFocusNode.hasFocus){
         Future.delayed(
           const Duration(microseconds: 500),
             () => scrollDown(),
         );
       }

    });


  }
  @override
  void dispose() {
    myFocusNode.dispose();
    messageController.dispose();
    super.dispose();
  }
  final ScrollController scrollController = ScrollController();
  void scrollDown(){
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(seconds: 1), curve: Curves.fastLinearToSlowEaseIn);
  }

  String? senderId;
  bool isUploading = false;



  void sendMessage() async {
    if (messageController.text.isNotEmpty && senderId != null) {
      await chatService.sendMessage(widget.receiverID, messageController.text);
      messageController.clear();
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          isUploading = true;
        });
        await uploadImageToFirebase(File(pickedFile.path), widget.receiverID);
        setState(() {
          isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to pick image: $e'),
        ),
      );
    }
  }


  Future<void> uploadImageToFirebase(File image, String receiverID) async {
    try {
      final Reference reference = FirebaseStorage.instance.ref().child(
        "images/${DateTime.now().microsecondsSinceEpoch}.png",
      );
      await reference.putFile(image);
      final String url = await reference.getDownloadURL();

      final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Add the image URL to the messages collection
      List<String> ids = [currentUserId, receiverID];
      ids.sort();
      String chatId = ids.join('_');

      await FirebaseFirestore.instance.collection("chat").doc(chatId).collection("messages").add({
        'senderId': currentUserId,
        'imageUrl': url,
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          content: Text("Upload Successful"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to upload image: $e'),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1B2020),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: widget.photoUrl.isEmpty
                  ? NetworkImage(
                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png')
                  : NetworkImage(widget.photoUrl),
            ),
            SizedBox(width: 15,),
            Text(
              widget.name,
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/duddle.png"),
            // Path to your background image
            fit: BoxFit.cover, // Make the image cover the whole screen
          ),
        ),
        child: Column(
          children: [
            Expanded(child: buildMessageList()),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      focusNode: myFocusNode,
                      controller: messageController,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Type a message',
                        labelStyle: GoogleFonts.roboto(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        filled: true,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isUploading)
                              CircularProgressIndicator()
                            else
                              IconButton(
                                onPressed: pickImage,
                                icon: Icon(Icons.image),
                              ),
                            SizedBox(width: 8),
                            IconButton(
                              onPressed: sendMessage,
                              icon: Icon(Icons.send),
                            ),
                          ],
                        ),
                        fillColor: const Color(0xff292F3F),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xff1B2020),
    );
  }

  Widget buildMessageList() {
    if (senderId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder(
      stream: chatService.getMessages(widget.receiverID, senderId!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }
        return ListView(
          controller: scrollController,
          children: snapshot.data!.docs.map<Widget>((doc) =>
              buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderId'] == senderId;

    return Column(
      crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: data['imageUrl'] == null? EdgeInsets.all(10):EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          decoration: BoxDecoration(
            color: data['imageUrl'] == null? isCurrentUser ? Colors.blue : Color.fromARGB(255, 104, 104, 104): Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (data['imageUrl'] != null)
                Container(
                      width: 200,
                      height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(image: NetworkImage(
                      data['imageUrl'],
                    ),
                      fit: BoxFit.cover,
                    )
                  ),

                ),
              if (data['message'] != null)
                Text(
                  data['message'],
                  style: GoogleFonts.inter(color: Colors.white),
                ),
            ],
          ),
        ),
      ],
    );
  }

}