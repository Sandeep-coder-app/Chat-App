import 'package:chat_app/Helper/helper_func.dart';
import 'package:chat_app/Widget/constants.dart';
import 'package:chat_app/Widget/toast.dart';
import 'package:chat_app/auth/login_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
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
                const Text(
                  "ChatHub",
                  style: TextStyle(
                    fontSize: 40, fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10),
                Image.asset("assets/chat1.png",width: 300, height: 300),
                const SizedBox(height: 20),
                    TextFormField(
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Enter your Full Name",
                    prefixIcon: const Icon(
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
                      fullName = value;
                    });
                  },

                  //check the validation
                  validator: (value) {
                    if(value!.isNotEmpty) {
                      return null;
                    } else {
                      return "Name cannot be empty";
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                    TextFormField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter your Email",
                    prefixIcon: const Icon(
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
                  decoration:  InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your Password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: primaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
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
                    register();
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
                      "Register",
                      textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text.rich(TextSpan(
                  text: "Already have an account? ",
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
                      ..onTap = () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
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
    if(formKey.currentState!.validate()) {
      await authService.registerUserWithEmailandPassword(fullName, email, password).then((value) async {
        if(value == true) {
          // Saving the shared preference state
          await Helper.saveUserLoggedInStatus(true);
          await Helper.saveUserEmailSF(email);
          await Helper.saveUserNameSF(fullName);
        } else {
          flutterToast(value);
        }
      });
    }
  }
}