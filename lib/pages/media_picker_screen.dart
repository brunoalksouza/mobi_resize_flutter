import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobi_resize_flutter/services/image_processing.dart';
import 'package:mobi_resize_flutter/services/video_processing.dart';

class MediaStatus {
  final String fileName;
  String status; // 'Pendente', 'Processando', 'Concluído', 'Erro'

  MediaStatus({required this.fileName, this.status = 'Pendente'});
}

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
  final ValueNotifier<List<MediaStatus>> _mediaStatuses = ValueNotifier([]);

  Future<void> _selectAndProcessMedia() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'mp4', 'mov', 'mkv'],
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) return;

      _isProcessing.value = true;
      _mediaStatuses.value = result.files.map((file) {
        return MediaStatus(fileName: file.name);
      }).toList();

      for (int i = 0; i < result.files.length; i++) {
        final file = result.files[i];
        final filePath = file.path;
        if (filePath == null) continue;

        final File fileObj = File(filePath);

        // Atualiza o status para 'Processando'
        _mediaStatuses.value[i].status = 'Processando..';
        _mediaStatuses.value = List.from(_mediaStatuses.value);

        String? outputPath;
        if (_isVideoFile(file.extension)) {
          outputPath = await _processVideo(fileObj);
        } else {
          outputPath = await _processImage(fileObj);
        }

        // Atualiza o status para 'Concluído' ou 'Erro'
        if (outputPath != null) {
          _mediaStatuses.value[i].status = 'Concluído';
        } else {
          _mediaStatuses.value[i].status = 'Erro';
        }
        _mediaStatuses.value = List.from(_mediaStatuses.value);
      }
    } catch (e) {
      _showError('Erro ao selecionar ou processar o arquivo: $e');
    } finally {
      _isProcessing.value = false;
    }
  }

  bool _isVideoFile(String? extension) {
    return ['mp4', 'mov', 'mkv'].contains(extension?.toLowerCase());
  }

  Future<String?> _processVideo(File file) async {
    try {
      final processedVideoPath = await widget.videoProcessor.processVideo(file);
      return processedVideoPath;
    } catch (e) {
      _showError('Erro ao processar vídeo: $e');
      return null;
    }
  }

  Future<String?> _processImage(File file) async {
    try {
      final processedImagePath = await widget.imageProcessor.processImage(file);
      return processedImagePath;
    } catch (e) {
      _showError('Erro ao processar imagem: $e');
      return null;
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ValueListenableBuilder<List<MediaStatus>>(
              valueListenable: _mediaStatuses,
              builder: (context, mediaStatuses, child) {
                bool isProcessingComplete = mediaStatuses.isNotEmpty &&
                    mediaStatuses.every(
                        (m) => m.status == 'Concluído' || m.status == 'Erro');

                if (mediaStatuses.isNotEmpty) {
                  double progress = mediaStatuses
                          .where((m) =>
                              m.status == 'Concluído' || m.status == 'Erro')
                          .length /
                      mediaStatuses.length;

                  return Expanded(
                    child: Column(
                      children: [
                        if (_isProcessing.value)
                          LinearProgressIndicator(value: progress),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Processadas: ${mediaStatuses.where((m) => m.status == 'Concluído').length} de ${mediaStatuses.length}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: mediaStatuses.length,
                            itemBuilder: (context, index) {
                              final media = mediaStatuses[index];
                              return Card(
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: ListTile(
                                  leading: Icon(
                                    media.status == 'Concluído'
                                        ? Icons.check_circle
                                        : media.status == 'Erro'
                                            ? Icons.error
                                            : Icons.hourglass_empty,
                                    color: media.status == 'Concluído'
                                        ? Colors.green
                                        : media.status == 'Erro'
                                            ? Colors.red
                                            : Colors.orange,
                                  ),
                                  title: Text(media.fileName),
                                  subtitle: Text('Status: ${media.status}'),
                                ),
                              );
                            },
                          ),
                        ),
                        // if (isProcessingComplete)
                        //   const Padding(
                        //     padding: EdgeInsets.symmetric(vertical: 16.0),
                        //     child: Card(
                        //       color: Colors.lightBlueAccent,
                        //       elevation: 2,
                        //       child: Padding(
                        //         padding: EdgeInsets.all(16.0),
                        //         child: Text(
                        //           'Redimensione mais mídias',
                        //           style: TextStyle(
                        //               fontSize: 18, color: Colors.white),
                        //           textAlign: TextAlign.center,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                  );
                } else {
                  return const Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported,
                              size: 100, color: Colors.grey),
                          SizedBox(height: 20),
                          Text(
                            'Nenhuma mídia selecionada.',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
