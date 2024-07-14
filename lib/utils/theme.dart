// lib/theme.dart

import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xffF8F9FA),
  fontFamily: 'AirbnbCereal',
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 28,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16,
    ),
    // Define other text styles as needed
  ),
);

const Color kPrimary = Color(0xff5B9EE1);
const Color kSecondary = Color(0xff707B81);
