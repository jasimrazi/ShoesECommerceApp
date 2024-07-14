import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String headerText;
  final String bodyText;

  const AuthHeader(
      {super.key, required this.bodyText, required this.headerText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.only(bottom: 50),
      child: Center(
        child: Column(
          children: [
            Text(
              headerText,
              style: TextStyle(
                  color: Color(0xff1A2530),
                  fontSize: 28,
                  fontWeight: FontWeight.w700),
            ),
            Text(bodyText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff707B81),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ))
          ],
        ),
      ),
    );
  }
}
