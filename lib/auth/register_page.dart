import 'package:chat_app/auth/login_page.dart';
import 'package:chat_app/helper/helper_fun.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/widget/toast.dart';
import 'package:chat_app/widget/widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
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
              children: [
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
                Image.asset("assets/chat2.png"),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Full Name",
                    prefixIcon: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    )
                  ),
                  onChanged: (val) {
                    setState(() {
                      fullName = val;
                    });
                  },
                  validator: (val) {
                    if(val!.isNotEmpty) {
                      return null;
                    } else {
                       Toast().toastMessage("Please enter your name");
                    }
                  }, 
                ),
                const SizedBox(
                  height: 15,
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
                    return RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                    ).hasMatch(val!)
                    ? null
                    : "Please enter a valid email";
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).primaryColor,
                    )
                  ),
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },

                  validator: (val) {
                    if(val!.length < 6) {
                      return "passwor must be at least 6 characters";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
             GestureDetector(
                  onTap: () {
                    register();
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
                      "Register",
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
                  text: "Already have an account?",
                  style: const TextStyle(
                    color: Colors.black, fontSize: 14,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Login now",
                      style: const TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline
                      ),
                      recognizer: TapGestureRecognizer()
                      ..onTap =() {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
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
  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.registerUserWithEmailandPassword(fullName, email, password).then((value) async{
        if(value == true) {
          await HelperFun.saveUserLoggedInStatus(true);
          await HelperFun.saveUserEmail(email);
          await HelperFun.saveUserName(fullName);
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