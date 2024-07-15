import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shoesapp/screens/auth/forget_password.dart';
import 'package:shoesapp/screens/auth/mobile_number.dart';
import 'package:shoesapp/screens/auth/sign_up.dart';
import 'package:shoesapp/screens/main_screen.dart';
import 'package:shoesapp/widget/appbar.dart';
import 'package:shoesapp/widget/auth_header.dart';
import 'package:shoesapp/widget/bottom_text_widget.dart';
import 'package:shoesapp/widget/elevated_button.dart';
import 'package:shoesapp/widget/textfield.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Unknown error occurred')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Trigger the Google authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google credentials
        final userCredential = await _auth.signInWithCredential(credential);

        // Navigate to Home screen after successful sign-in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loginWithOtp() {
    // Implement your login with OTP functionality here
    // For example, navigate to another screen for OTP input
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MobileNumberPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Sign In',),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const AuthHeader(
                headerText: 'Hello Again!',
                bodyText: 'Welcome Back You’ve Been Missed!',
              ),
              CustomTextField(
                labelText: 'Email Address',
                controller: _emailController,
              ),
              CustomTextField(
                labelText: 'Password',
                isPassword: true,
                controller: _passwordController,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ForgetPassword()),
                  );
                },
                child: const Text(
                  'Recovery Password',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff707B81),
                  ),
                ),
              ),
              CustomElevatedButton(
                onPressed: _signInWithEmailAndPassword,
                text: 'Sign In',
                isLoading: _isLoading,
              ),
              CustomElevatedButton(
                onPressed: _signInWithGoogle,
                text: 'Sign In with Google',
                isGoogle: true,
                isLoading: _isLoading,
              ),
              CustomElevatedButton(
                onPressed: _loginWithOtp,
                text: 'Login with OTP',
                isLoading: _isLoading,
              ),
              CustomBottomTextWidget(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignUp()),
                  );
                },
                firstText: 'Don’t have an account?',
                secondText: ' Sign Up for free',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
