import 'package:flutter/material.dart';

class AppTheme {
  ThemeData themeData() {
    return ThemeData(
      fontFamily: 'Montserrat',
      primaryColor: Colors.teal[400],
      accentColor: Colors.amber[100],
      buttonColor: Colors.teal[400],
      textTheme: TextTheme(
        headline1: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 25,
        ),
        headline3: TextStyle(fontSize: 25),
        headline4: TextStyle(fontSize: 20),
        headline5: TextStyle(fontSize: 18),
        bodyText1: TextStyle(fontSize: 16),
        subtitle1: TextStyle(fontSize: 15),
      ),
    );
  }
}
