import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String headerText;
  final String bodyText;

  const AuthHeader(
      {super.key, required this.bodyText, required this.headerText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(bottom: 50),
      child: Center(
        child: Column(
          children: [
            Text(
              headerText,
              style: const TextStyle(
                  color: Color(0xff1A2530),
                  fontSize: 28,
                  fontWeight: FontWeight.w700),
            ),
            Text(bodyText,
                textAlign: TextAlign.center,
                style: const TextStyle(
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
