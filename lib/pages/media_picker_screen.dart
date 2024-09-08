import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobi_resize_flutter/env.dart';
import 'package:mobi_resize_flutter/services/image_processing.dart';
import 'package:mobi_resize_flutter/services/video_processing.dart';
import 'package:mobi_resize_flutter/widgets/image_widget.dart';

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

  // Criação dos ValueNotifiers para o estado de processamento e caminho de saída
  final ValueNotifier<bool> _isProcessing = ValueNotifier(false);
  final ValueNotifier<String?> _outputFilePath = ValueNotifier(null);

  Future<void> _selectMedia() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'mp4', 'mov'],
    );

    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.single.path;
      if (filePath != null) {
        final File file = File(filePath);

        // Atualizar o estado usando ValueNotifier
        _isProcessing.value = true;
        _outputFilePath.value = null;

        if (result.files.single.extension?.toLowerCase() == 'mp4' ||
            result.files.single.extension?.toLowerCase() == 'mov') {
          final String? processedVideoPath =
              await widget.videoProcessor.processVideo(file);
          _isProcessing.value = false;
          _outputFilePath.value = processedVideoPath;
        } else {
          final Uint8List? processedImageBytes =
              await widget.imageProcessor.processImage(file);
          _mediaBytes = processedImageBytes;
          _isProcessing.value = false;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Redimensionador de Mídia',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              children: [
                const Text(
                  'Selecione a mídia para processar ',
                  style: TextStyle(color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.upload_file,
                      color: Colors.white, size: 30),
                  onPressed: _selectMedia,
                ),
              ],
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
              child: ValueListenableBuilder<bool>(
                valueListenable: _isProcessing,
                builder: (context, isProcessing, child) {
                  if (isProcessing) {
                    return CircularProgressIndicator();
                  } else {
                    return ValueListenableBuilder<String?>(
                      valueListenable: _outputFilePath,
                      builder: (context, outputPath, child) {
                        if (outputPath != null) {
                          return const Column(
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.green, size: 50),
                              Text(
                                  'Vídeo processado e adicionado com sucesso em $caminhoPasta'),
                            ],
                          );
                        } else {
                          return ImageWidget(imageBytes: _mediaBytes);
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
