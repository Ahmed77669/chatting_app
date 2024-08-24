import 'package:chating_app/chat_service.dart';
import 'package:chating_app/provider/UserInputProvider.dart';
import 'package:chating_app/screens/Welcome.dart';
import 'package:chating_app/screens/chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
// import 'package:chating_app/screens/chats.dart;
import '../firebase/authService.dart';

void main() {
  runApp(const MyHome());
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Authservice authService = Authservice();
  final chat_service chatService = chat_service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1B2020),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Messages',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                authService.logout(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Color(0xff1B2020),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              SizedBox(width: 17,),
Text("RECENT" , style: GoogleFonts.quicksand(fontSize: 18,color: Colors.grey),),
            ]),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 150, // Set the desired height
              child: buildRecentLists(),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xff292F3F),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0)
                  ),
                ),
                padding: EdgeInsets.all(0), // Add padding if needed.
                child: buildLists(),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xff1B2020),
    );
  }

  Widget buildLists() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: chatService.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }
        if (snapshot.data == null) {
          return const Text("No data");
        }
        return ListView(
          children: snapshot.data!.map<Widget>((userData) {
            return buildListItem(userData, context);
          }).toList(),
        );
      },
    );
  }

  Widget buildListItem(Map<String, dynamic> userData, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          BottomToTopPageRoute(
              page: Chats(
            name: userData["name"],
            receiverID: userData["uid"],
                photoUrl: userData["imageUrl"]!=null?userData["imageUrl"]: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
          )),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff292F3F),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 15),
                CircleAvatar(
                  radius: 25,
                  backgroundImage: userData["imageUrl"] == null
                      ? const NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png')
                      : NetworkImage(userData["imageUrl"]),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData["name"],
                      style:
                          GoogleFonts.inter(fontSize: 20, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "hey, I'm using Quick chat",
                      style:
                          GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                    )
                  ],
                ),
                // Text(userData["Timestamp"]),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget buildRecentLists() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: chatService.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }
        if (snapshot.data == null) {
          return const Text("No data");
        }
        return ListView(
          scrollDirection: Axis.horizontal,
          children: snapshot.data!.map<Widget>((userData) {
            return buildRecentListItem(userData, context);
          }).toList(),
        );
      },
    );
  }

  Widget buildRecentListItem(
      Map<String, dynamic> userData, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          BottomToTopPageRoute(
              page: Chats(
            name: userData["name"],
            receiverID: userData["uid"],
                photoUrl: userData["imageUrl"],
          )),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            const SizedBox(width: 15),
            CircleAvatar(
              radius: 25,
              backgroundImage: userData["imageUrl"] == null
                  ? NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png')
                  : NetworkImage(userData["imageUrl"]),
            ),
            const SizedBox(height: 8),
            Container(
              width: 100,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      userData["name"].split(" ")[0],
                      style: GoogleFonts.quicksand(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ]),
            ),
            // Text(userData["Timestamp"]),
            // const SizedBox(height: 10),
          ],
          // const Divider(
          //   color: Colors.grey,
          //   thickness: 1,
          //   height: 20,
          // ),
        ),
      ),
    );
  }
}
