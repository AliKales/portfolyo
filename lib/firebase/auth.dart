import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:portfolyo/everything/funcs.dart';
import 'package:portfolyo/everything/simple_UIs.dart';

class Auth {
  static Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  static Future<String?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  static Future signOut({
    required context,
  }) async {
    try {
      SimpleUIs().showProgressIndicator(context);
      await FirebaseAuth.instance.signOut();
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
    } on FirebaseAuthException {
      return;
    } catch (e) {
      return;
    }
  }

  String? getUID() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  String? getEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }

  bool isItMe() {
    return getUID() == Funcs.uID;
  }
}
