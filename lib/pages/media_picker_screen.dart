import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobi_resize_flutter/services/image_processing.dart';
import 'package:mobi_resize_flutter/services/video_processing.dart';
import 'package:mobi_resize_flutter/widgets/image_widget.dart';

// Widget for picking and processing media (images/videos)
class MediaPickerScreen extends StatefulWidget {
  final ImageProcessingService imageProcessor;
  final VideoProcessingService videoProcessor;

  MediaPickerScreen({
    required this.imageProcessor,
    required this.videoProcessor,
  });

  @override
  _MediaPickerScreenState createState() => _MediaPickerScreenState();
}

class _MediaPickerScreenState extends State<MediaPickerScreen> {
  Uint8List? _mediaBytes;

  Future<void> _selectMedia() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'mp4', 'mov'],
    );

    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.single.path;
      if (filePath != null) {
        final File file = File(filePath);

        if (result.files.single.extension?.toLowerCase() == 'mp4' ||
            result.files.single.extension?.toLowerCase() == 'mov') {
          final Uint8List? processedVideoBytes =
              await widget.videoProcessor.processVideo(file);
          setState(() {
            _mediaBytes = processedVideoBytes;
          });
        } else {
          final Uint8List? processedImageBytes =
              await widget.imageProcessor.processImage(file);
          setState(() {
            _mediaBytes = processedImageBytes;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Selecionar Mídia',
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
              onPressed: _selectMedia,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: ImageWidget(imageBytes: _mediaBytes),
            ),
            // Você pode adicionar aqui um widget para exibir o vídeo processado, se necessário
          ],
        ),
      ),
    );
  }
}
