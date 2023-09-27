import 'package:chat_app/auth/register_page.dart';
import 'package:chat_app/widget/widget.dart';
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
                      "Log In",
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
}