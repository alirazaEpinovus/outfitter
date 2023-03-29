import 'package:flutter/material.dart';

class Constant {
  //App related strings
  static String appName = "Outfitters";

  //Colors for theme
  static Color lightPrimary = Colors.white;
  static Color darkPrimary = Colors.black;
  static Color lightBG = Colors.white;
  static Color darkBG = Colors.black;

  static ThemeData lightTheme = ThemeData(
    fontFamily: "BentonSans",
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: darkPrimary,
    primaryColorLight: darkPrimary,
    scaffoldBackgroundColor: lightBG,
    // cursorColor: darkPrimary,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        headline1: TextStyle(
          fontFamily: "BentonSans",
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: "BentonSans Cond Regular",
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: lightPrimary,
    primaryColorLight: lightPrimary,
    primaryColorDark: Colors.white,
    scaffoldBackgroundColor: darkBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        headline1: TextStyle(
          fontFamily: "BentonSans Cond Regular",
          color: lightBG,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}
