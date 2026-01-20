import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static final Color _lightPrimaryColor = Colors.blueGrey.shade50;
  static const Color _lightTextColorPrimary = Colors.black;

  static const _lightTextColorRed = Colors.red;

  static final Color _darkPrimaryColor = Colors.blueGrey.shade900;
  static const Color _darkTextColorPrimary = Colors.white;

  static const _darkTextColorGreen = Colors.green;

  static const Color _accentColor = Color.fromRGBO(74, 217, 217, 1);
  static final TextStyle _lightHeadingText = TextStyle(
      color: _lightPrimaryColor,
      fontFamily: "Rubik",
      fontSize: 20,
      fontWeight: FontWeight.bold);

  static final TextStyle _lightBodyText = TextStyle(
      color: _lightPrimaryColor,
      fontFamily: "Rubik",
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold,
      fontSize: 16);
  static final TextStyle _lightTextFieldText = const TextStyle(
      color: _lightTextColorRed,
      fontFamily: "Rubik",
      fontSize: 13,
      fontWeight: FontWeight.bold);

  static final TextTheme _lightTextTheme = TextTheme(
    titleMedium: _lightBodyText,
    titleLarge: _lightHeadingText,
    headlineMedium: _lightTextFieldText,
  );

  static final TextStyle _darkThemeHeadingTextStyle =
      _lightHeadingText.copyWith(color: _darkPrimaryColor);

  static final TextStyle _darkThemeBodyeTextStyle =
      _lightBodyText.copyWith(color: _darkPrimaryColor);

  static final TextStyle _darkThemeTextFieldTextStyle =
      _lightTextFieldText.copyWith(
    color: _darkTextColorGreen,
    fontSize: 20,
  );

  static final TextTheme _darkTextTheme = TextTheme(
      titleMedium: _darkThemeBodyeTextStyle,
      headlineMedium: _darkThemeTextFieldTextStyle,
      titleLarge: _darkThemeHeadingTextStyle);

  static final ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: _lightPrimaryColor,
      colorScheme: ColorScheme.light(
        primary: _lightTextColorPrimary,
        onPrimary: _lightPrimaryColor,
        secondary: _accentColor,
        primaryContainer: _lightPrimaryColor,
      ),
      textTheme: _lightTextTheme);

  static final ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: _darkPrimaryColor,
      colorScheme: ColorScheme.dark(
        primary: _darkTextColorPrimary,
        secondary: _accentColor,
        onPrimary: _darkPrimaryColor,
        primaryContainer: _darkPrimaryColor,
      ),
      textTheme: _darkTextTheme);
}
