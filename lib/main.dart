import 'package:chating_app/provider/UserInputProvider.dart';
import 'package:chating_app/screens/Welcome.dart';
import 'package:chating_app/screens/account.dart';
import 'package:chating_app/screens/home.dart';
import 'package:chating_app/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
   MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const welcome(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(

      bottomNavigationBar: NavigationBar(
        backgroundColor: Color(0xff292F3F),
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color.fromARGB(255, 207, 207, 207),
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          const NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.messenger_sharp,color: Colors.white,),
            ),
            label: 'Messages',
          ),
          // NavigationDestination(
          //   icon: Badge(child: Icon(Icons.notifications_sharp)),
          //   label: 'Notifications',
          // ),
          const NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person,color: Colors.white,),
            label: 'Account',
          ),
        ],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: const [
          Home(),
          // login(),
          account(),
        ],
      ),

    );
    
  }
}
