import 'package:chat_app/auth/login_page.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/helper/helper_fun.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
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

  bool _isSignedIn = false;

  getUserLoggedIn() async {
    await HelperFun.getUserLoggedInStatus().then((value){
      if(value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserLoggedIn();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _isSignedIn ? const HomePage() : const LoginPage(),
    );
  }
}