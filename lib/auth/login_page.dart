import 'package:chat_app/Helper/helper_func.dart';
import 'package:chat_app/Pages/home_page.dart';
import 'package:chat_app/Widget/constants.dart';
import 'package:chat_app/Widget/toast.dart';
import 'package:chat_app/auth/register_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/database_service.dart';
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
                const Text("ChatHub",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
                Image.asset("assets/chat1.png", width: 300, height: 300,),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter your Email",
                    prefixIcon: Icon(
                      Icons.email,
                      color: primaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:const BorderSide(width: 3, color: Colors.black, style: BorderStyle.solid)
                    )
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },

                  //check the validation
                  validator: (value) {
                    return RegExp( r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value!)
                    ? null
                    : "Please enter a valid email";
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your Password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: primaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(width: 3, color: Colors.black, style: BorderStyle.solid),
                    )
                  ),

                  validator: (value) {
                    if(value!.length < 6) {
                      return "Password must be at least 6 characters";
                    } else {
                      return null;
                    }
                  },

                  onChanged: (value) {
                    setState(() {
                      password = value;
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
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primaryColor
                    ),
                    child: const Text(
                      "Sign In",
                      textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                Text.rich(TextSpan(
                  text: "Don't have an account? ",
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
                  ],
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
      await authService.loginWithUserNameandPassword(email, password).then((value) async {
        if(value == true) {
          QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);

          // Saving the value to our shared preferences
          await Helper.saveUserLoggedInStatus(true);
          await Helper.saveUserEmailSF(email);
          await Helper.saveUserNameSF(snapshot.docs[0]['fullName']);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          flutterToast(value);
        }
      });
    }
  }
}