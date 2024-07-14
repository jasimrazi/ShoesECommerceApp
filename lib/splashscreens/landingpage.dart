// lib/landing_page.dart

import 'package:flutter/material.dart';
import 'package:shoesapp/splashscreens/onboard1.dart'; // Import your next screen

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3)); // Delay for 3 seconds
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              Onboard1()), // Replace HomeScreen() with your desired screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            'OXY BOOTS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
