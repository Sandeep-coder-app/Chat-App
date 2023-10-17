import 'package:chat_app/Helper/helper_func.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
 
  //login
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)).user!;

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
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password)).user!;

        if(user != null) {
          await DatabaseService(uid: user.uid);

          return true;
        }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //signOut
  Future signOut() async {
    try {
      await Helper.saveUserLoggedInStatus(false);
      await Helper.saveUserEmailSF("");
      await Helper.saveUserNameSF("");
    } catch (e) {
      return null;
    }
  }
}