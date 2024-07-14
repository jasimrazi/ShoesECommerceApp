import 'package:flutter/material.dart';

class CustomBottomTextWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String firstText;
  final String secondText;

  const CustomBottomTextWidget({
    Key? key,
    required this.onPressed,
    required this.firstText,
    required this.secondText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              firstText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xff707B81),
              ),
            ),
            Text(
              secondText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xff1A2530),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
