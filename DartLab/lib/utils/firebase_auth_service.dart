import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  static Future<void> _showMyDialog(
      BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<User?> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showMyDialog(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _showMyDialog(context, 'Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        _showMyDialog(context, 'Invalid email format.');
      }
    }
    return null;
  }

  Future<User?> signUpWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showMyDialog(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showMyDialog(context, 'The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        _showMyDialog(context, 'Invalid email format.');
      }
    } catch (e) {
      _showMyDialog(context, e.toString());
    }
    return null;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
