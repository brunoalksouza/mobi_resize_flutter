import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobi_resize_flutter/services/image_processing.dart';
import 'package:mobi_resize_flutter/services/video_processing.dart';

class MediaPickerScreen extends StatefulWidget {
  final ImageProcessingService imageProcessor;
  final VideoProcessingService videoProcessor;

  const MediaPickerScreen({
    super.key,
    required this.imageProcessor,
    required this.videoProcessor,
  });

  @override
  _MediaPickerScreenState createState() => _MediaPickerScreenState();
}

class _MediaPickerScreenState extends State<MediaPickerScreen> {
  // ValueNotifiers para estado de processamento e caminhos de saída
  final ValueNotifier<bool> _isProcessing = ValueNotifier(false);
  final ValueNotifier<String?> _outputFilePath = ValueNotifier(null);
  final ValueNotifier<String?> _outputImagePath = ValueNotifier(null);

  Future<void> _selectMedia() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'mp4', 'mov', 'mkv'],
    );

    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.single.path;
      if (filePath != null) {
        final File file = File(filePath);

        _isProcessing.value = true;
        _outputFilePath.value = null;
        _outputImagePath.value = null;

        if (result.files.single.extension?.toLowerCase() == 'mp4' ||
            result.files.single.extension?.toLowerCase() == 'mov' ||
            result.files.single.extension?.toLowerCase() == 'mkv') {
          final String? processedVideoPath =
              await widget.videoProcessor.processVideo(file);
          _isProcessing.value = false;
          _outputFilePath.value = processedVideoPath;
        } else {
          final String? processedImagePath =
              await widget.imageProcessor.processImage(file);
          _isProcessing.value = false;
          _outputImagePath.value = processedImagePath;
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
        child: ValueListenableBuilder<bool>(
          valueListenable: _isProcessing,
          builder: (context, isProcessing, child) {
            if (isProcessing) {
              return const CircularProgressIndicator();
            } else {
              // Usando AnimatedBuilder para escutar ambos os ValueNotifiers
              return AnimatedBuilder(
                animation:
                    Listenable.merge([_outputFilePath, _outputImagePath]),
                builder: (context, child) {
                  if (_outputFilePath.value != null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 50),
                        Text(
                            'Vídeo processado e adicionado com sucesso em ${_outputFilePath.value}'),
                      ],
                    );
                  } else if (_outputImagePath.value != null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 50),
                        Text(
                            'Imagem processada e salva com sucesso em ${_outputImagePath.value}'),
                      ],
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Center(
                        child: Text('Nenhuma mídia selecionada.'),
                      ),
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
