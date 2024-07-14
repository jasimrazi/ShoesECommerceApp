import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoesapp/screens/auth/sign_in.dart';
import 'package:shoesapp/screens/home.dart';
import 'package:shoesapp/screens/main_screen.dart';

class AuthState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CupertinoActivityIndicator());
        } else if (snapshot.hasData) {
          return MainScreen();
        } else {
          return SignIn();
        }
      },
    );
  }
}
