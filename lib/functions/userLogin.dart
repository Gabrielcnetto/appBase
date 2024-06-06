import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserLoginApp with ChangeNotifier {
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> deslogar() async {
    firebaseAuth.signOut();
  }

  Future<void> fazerLogin(String email, String password) async {
    firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
