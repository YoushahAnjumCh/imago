import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: Text(text),
    backgroundColor: Colors.white,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(50),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
