import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoesapp/screens/main_screen.dart';
import 'package:shoesapp/utils/theme.dart';
import 'package:shoesapp/widget/appbar.dart';
import 'package:shoesapp/widget/auth_header.dart';
import 'package:shoesapp/widget/elevated_button.dart';

class OtpVerificationPage extends StatefulWidget {
  final String verificationId;

  OtpVerificationPage({required this.verificationId});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      _otpControllers[i].addListener(() {
        if (_otpControllers[i].text.length == 1) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final otp = _otpControllers.map((controller) => controller.text).join();
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Failed to verify OTP')),
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
      appBar: const CustomAppBar(title: 'Verify OTP',),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(
                headerText: 'Enter OTP',
                bodyText: 'We have sent you an OTP. Please enter it below',
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 40,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      cursorColor: kPrimary,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: kPrimary
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: _verifyOtp,
                text: 'Verify OTP',
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
