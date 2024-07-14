import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoesapp/screens/home.dart';
import 'package:shoesapp/screens/main_screen.dart';
import 'package:shoesapp/widget/appbar.dart';
import 'package:shoesapp/widget/auth_header.dart';
import 'package:shoesapp/widget/bottom_text_widget.dart';
import 'package:shoesapp/widget/elevated_button.dart';
import 'package:shoesapp/widget/textfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _signUpWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Optionally, update the user's display name
      await userCredential.user?.updateDisplayName(_nameController.text.trim());

      // Create 'userinfo' collection for the new user
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .collection('userinfo')
          .doc('placeholder')
          .set({
        'name': _nameController.text.trim(), // Store user's name
      });

      // Create 'cart' collection for the new user
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .collection('cart')
          .doc('placeholder')
          .set({});

      // Create 'favourite' collection for the new user
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .collection('favourite')
          .doc('placeholder')
          .set({});

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
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
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);

        // Create 'userinfo' collection for the new user
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('userinfo')
            .doc('placeholder')
            .set({
          'name': _auth.currentUser!.displayName ??
              'Anonymous', // Store user's name
        });

        // Create 'cart' collection for the new user
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('cart')
            .doc('placeholder')
            .set({});

        // Create 'favourite' collection for the new user
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('favourite')
            .doc('placeholder')
            .set({});

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Unknown error occurred')),
      );
    } finally {
      setState(() {
        _isGoogleLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Sign Up', isBack: true,),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AuthHeader(
                headerText: 'Create Account',
                bodyText: 'Let’s Create Account Together',
              ),
              CustomTextField(
                labelText: 'Your Name',
                controller: _nameController,
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
              CustomElevatedButton(
                onPressed: _signUpWithEmailAndPassword,
                text: 'Sign Up',
                isLoading: _isLoading,
              ),
              CustomElevatedButton(
                onPressed: _signInWithGoogle,
                text: 'Sign Up with Google',
                isGoogle: true,
                isLoading: _isGoogleLoading,
              ),
              SizedBox(height: 20),
              CustomBottomTextWidget(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                firstText: 'Already have an account?',
                secondText: ' Sign In',
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
