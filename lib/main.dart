import 'package:chat_app/Screen/home_page.dart';
import 'package:chat_app/Widget/constanst.dart';
import 'package:chat_app/auth/login_page.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/helper/helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
     getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await Helper.getUserLoggedInStatus().then((value) {
      if(value != null) {
        setState(() {
          isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: isSignedIn ? const HomePage() : const LoginPage(),
    );
  }
}
