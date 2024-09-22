import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
void ShowError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.red)),
    ),
  );
}
