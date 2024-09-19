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
  // ignore: library_private_types_in_public_api
  _MediaPickerScreenState createState() => _MediaPickerScreenState();
}

class _MediaPickerScreenState extends State<MediaPickerScreen> {
  final ValueNotifier<bool> _isProcessing = ValueNotifier(false);
  final ValueNotifier<String?> _outputMediaPath = ValueNotifier(null);

  Future<void> _selectAndProcessMedia() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'mp4', 'mov', 'mkv'],
      );

      if (result == null || result.files.isEmpty) return;

      final filePath = result.files.single.path;
      if (filePath == null) return;

      final File file = File(filePath);
      _isProcessing.value = true;
      _outputMediaPath.value = null;

      if (_isVideoFile(result.files.single.extension)) {
        await _processVideo(file);
      } else {
        await _processImage(file);
      }
    } catch (e) {
      _showError('Erro ao selecionar ou processar o arquivo: $e');
    }
  }

  bool _isVideoFile(String? extension) {
    return ['mp4', 'mov', 'mkv'].contains(extension?.toLowerCase());
  }

  Future<void> _processVideo(File file) async {
    try {
      final processedVideoPath = await widget.videoProcessor.processVideo(file);
      _outputMediaPath.value = processedVideoPath;
    } catch (e) {
      _showError('Erro ao processar vídeo: $e');
    } finally {
      _isProcessing.value = false;
    }
  }

  Future<void> _processImage(File file) async {
    try {
      final processedImagePath = await widget.imageProcessor.processImage(file);
      _outputMediaPath.value = processedImagePath;
    } catch (e) {
      _showError('Erro ao processar imagem: $e');
    } finally {
      _isProcessing.value = false;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.red))),
    );
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
          const Text(
            'Selecione a mídia para processar ',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: IconButton(
              icon:
                  const Icon(Icons.upload_file, color: Colors.white, size: 30),
              onPressed: _selectAndProcessMedia,
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
            }
            return ValueListenableBuilder<String?>(
              valueListenable: _outputMediaPath,
              builder: (context, outputPath, child) {
                if (outputPath != null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 50),
                      Text('Mídia processada com sucesso em $outputPath'),
                    ],
                  );
                }
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Center(child: Text('Nenhuma mídia selecionada.')),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
