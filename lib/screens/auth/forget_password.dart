import 'package:flutter/material.dart';
import 'package:shoesapp/widget/appbar.dart';
import 'package:shoesapp/widget/auth_header.dart';
import 'package:shoesapp/widget/elevated_button.dart';
import 'package:shoesapp/widget/textfield.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Forget Password',isBack: true,),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const AuthHeader(
              headerText: 'Recovery Password',
              bodyText: 'Please Enter Your Email Address To Recieve a Verification Code',
            ),
            const CustomTextField(labelText: 'Email Address'),
            
            CustomElevatedButton(onPressed: () {}, text: 'Continue'),
            
          ],
        ),
      ),
    );
  }
}