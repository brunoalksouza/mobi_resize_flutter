import 'package:flutter/material.dart';
import 'package:mobi_resize_flutter/pages/image_picker_screen.dart';
import 'package:mobi_resize_flutter/services/image_processing.dart';

void main() {
  runApp(MyApp());
}

// Application main widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImagePickerScreen(imageProcessor: ImageProcessor()),
    );
  }
}
