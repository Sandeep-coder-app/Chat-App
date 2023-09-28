import 'package:chat_app/auth/register_page.dart';
import 'package:chat_app/helper/helper_fun.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/database_services.dart';
import 'package:chat_app/widget/toast.dart';
import 'package:chat_app/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Chat",style: TextStyle(fontSize: 40, color: Colors.black87, fontWeight: FontWeight.bold),),
                    Text("Hub", style: TextStyle(fontSize: 40, color: Colors.blue, fontWeight: FontWeight.bold),)
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // const Text(
                //   "Welcome to ChatHub, Where meaningful connections happen effortlessly",
                //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                // ),
                Image.asset("assets/chat2.png",
                fit: BoxFit.cover,),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Email",
                    prefixIcon: Icon(
                      Icons.email,
                      color: Theme.of(context).primaryColor,
                    )
                  ),
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  validator: (val) {
                    return RegExp( r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(val!)
                    ? null
                    : "Please enter a valid email";
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).primaryColor,
                    )
                  ),
                  validator: (val) {
                    if(val!.length < 6){
                      return "Password must be at least 6 characters";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    login();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.redAccent
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text.rich(TextSpan(
                  text: "Don't have an account?",
                  style: const TextStyle(
                    color: Colors.black, fontSize: 14
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Register here",
                      style: const TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline
                      ),
                      recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                      }
                    )
                  ]
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    if(formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.loginWithUserNameandPassword(email, password).then((value) async {
        if(value == true) {
          QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .gettingUserData(email);

          //saving the values to our shared preferences
          await HelperFun.saveUserLoggedInStatus(true);
          await HelperFun.saveUserEmail(email);
          await HelperFun.saveUserName(snapshot.docs[0]['fullName']);

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          Toast().toastMessage(value.toString());
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}