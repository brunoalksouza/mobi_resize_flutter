import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobi_resize_image_flutter/services/image_processing.dart';
import 'package:mobi_resize_image_flutter/widgets/image_widget.dart';

// Widget for picking and processing images
class ImagePickerScreen extends StatefulWidget {
  final ImageProcessingService imageProcessor;

  ImagePickerScreen({required this.imageProcessor});

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  Uint8List? _imageBytes;

  Future<void> _selectImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.single.path;
      if (filePath != null) {
        final File file = File(filePath);
        final Uint8List? processedImageBytes =
            await widget.imageProcessor.processImage(file);
        setState(() {
          _imageBytes = processedImageBytes;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Redimensionar Imagem',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: IconButton(
              icon: const Icon(
                Icons.upload_file,
                color: Colors.white,
                size: 30,
              ),
              onPressed: _selectImage,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ImageWidget(imageBytes: _imageBytes),
          ],
        ),
      ),
    );
  }
}
