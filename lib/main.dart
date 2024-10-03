import 'package:flutter/material.dart';
import 'package:mobi_resize_flutter/pages/media_picker_screen.dart';
import 'package:mobi_resize_flutter/services/image_processing.dart';
import 'package:mobi_resize_flutter/services/video_processing.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// Application main widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: MediaPickerScreen(
        imageProcessor: ImageProcessor(),
        videoProcessor: VideoProcessor(),
      ),
    );
  }
}
