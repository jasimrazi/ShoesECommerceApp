import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoesapp/screens/auth/sign_in.dart';
import 'package:shoesapp/screens/main_screen.dart';

class AuthState extends StatelessWidget {
  const AuthState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (snapshot.hasData) {
          return const MainScreen();
        } else {
          return const SignIn();
        }
      },
    );
  }
}
