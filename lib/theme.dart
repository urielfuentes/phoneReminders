import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var appTheme = ThemeData(
  fontFamily: GoogleFonts.nunito().fontFamily,
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Colors.black87,
  ),
  // brightness: Brightness.dark,
  textTheme: const TextTheme(
    bodyText1: TextStyle(fontSize: 18),
    bodyText2: TextStyle(fontSize: 16),
    button: TextStyle(
      letterSpacing: 1.5,
      fontWeight: FontWeight.bold,
    ),
    headline1: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 40, color: Colors.black87),
    headline2: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 32, color: Colors.black87),
    subtitle1: TextStyle(
      color: Colors.black87,
    ),
  ),
  buttonTheme: const ButtonThemeData(),
);
