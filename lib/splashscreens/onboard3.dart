import 'package:flutter/material.dart';

class Onboard3 extends StatelessWidget {
  const Onboard3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.rotate(
            angle: -0.3,
            child: Image.asset(
              'assets/images/shoe3.png',
            ),
          ),
          Spacer(),
          Text(
            'Summer Shoes Nike 2022',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Amet Minim Lit Nodeseru Saku Nandu sit Alique Dolor',
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