import 'package:chat_app/helper/helper_fun.dart';
import 'package:chat_app/services/database_services.dart';
import 'package:chat_app/widget/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;

      if(user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //register

  Future registerUserWithEmailandPassword(String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;

      if(user != null) {
      await DatabaseService(uid: user.uid).savingUserData(fullName, email);
      return true;
      }
        }on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //signOut
  Future signOut() async {
    try {
      await HelperFun.saveUserLoggedInStatus(false);
      await HelperFun.saveUserEmail("");
      await HelperFun.saveUserName("");
      await firebaseAuth.signOut();
    } catch (e) {
      Toast().toastMessage(e.toString());
    }
  }
}