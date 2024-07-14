import 'package:flutter/material.dart';

class Onboard2 extends StatelessWidget {
  const Onboard2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.rotate(
            angle: -0.3,
            child: Image.asset(
              'assets/images/shoe2.png',
            ),
          ),
          Spacer(),
          Text(
            'Follow Latest Style Shoes',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'There Are Many Beautiful And Attractive Plants To Your Room',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xff707B81),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
