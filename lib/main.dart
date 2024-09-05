import 'package:flutter/material.dart';
import 'package:mobi_resize_flutter/pages/media_picker_screen.dart';
import 'package:mobi_resize_flutter/services/image_processing.dart';
import 'package:mobi_resize_flutter/services/video_processing.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

// Application main widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MediaPickerScreen(
        imageProcessor: ImageProcessor(),
        videoProcessor: VideoProcessor(),
      ),
    );
  }
}
