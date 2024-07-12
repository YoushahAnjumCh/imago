import 'package:flutter/material.dart';

class AppTheme {
  static final darkThemeMode = ThemeData.dark().copyWith(
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      hintStyle: TextStyle(color: Colors.white),
    ),
  );
}
