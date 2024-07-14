import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoesapp/screens/auth/otp.dart';
import 'package:shoesapp/screens/home.dart';
import 'package:shoesapp/screens/main_screen.dart';
import 'package:shoesapp/widget/appbar.dart';
import 'package:shoesapp/widget/auth_header.dart';
import 'package:shoesapp/widget/textfield.dart';
import 'package:shoesapp/widget/elevated_button.dart';

class MobileNumberPage extends StatefulWidget {
  @override
  _MobileNumberPageState createState() => _MobileNumberPageState();
}

class _MobileNumberPageState extends State<MobileNumberPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController =
      TextEditingController(text: '+91');
  bool _isLoading = false;

  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneController.text.trim(),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Failed to send OTP')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationPage(
                verificationId: verificationId,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Send OTP',isBack: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(
                headerText: 'Enter Mobile Number',
                bodyText: 'We will send you an OTP to verify your number',
              ),
              CustomTextField(
                labelText: 'Mobile Number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              CustomElevatedButton(
                onPressed: _sendOtp,
                text: 'Send OTP',
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
