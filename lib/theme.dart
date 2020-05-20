import 'package:flutter/material.dart';

class AppTheme {
  ThemeData themeData() {
    return ThemeData(
      primaryColor: Colors.blue[400],
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        bodyText1: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
