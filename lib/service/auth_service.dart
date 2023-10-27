import 'package:chat_app/helper/helper.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login

  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      return true;
        } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // register

  Future registerUserWithEmailandPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      // call our database service to update the user data.
      await DatabaseService(uid: user.uid).savingUserData(fullName, email);
      return true;
        } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // signout

  Future signOut() async {
    try {
      await Helper.saveUserLoggedInStatus(false);
      await Helper.saveUserEmailSF("");
      await Helper.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
