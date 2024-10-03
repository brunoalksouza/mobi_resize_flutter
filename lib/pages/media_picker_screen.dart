import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:cross_file/cross_file.dart';
import 'package:mobi_resize_flutter/models/media_status.dart';
import 'package:mobi_resize_flutter/services/file_handler.dart';
import 'package:mobi_resize_flutter/services/media_processor.dart';
import 'package:mobi_resize_flutter/widgets/show_error.dart';
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
  final ValueNotifier<bool> _isProcessing = ValueNotifier(false);
  final ValueNotifier<List<MediaStatus>> _mediaStatuses = ValueNotifier([]);
  late MediaProcessor _mediaProcessor;
  final FileHandler _fileHandler = FileHandler();

  @override
  void initState() {
    super.initState();
    _mediaProcessor = MediaProcessor(
      imageProcessor: widget.imageProcessor,
      videoProcessor: widget.videoProcessor,
    );
  }

  Future<void> _selectAndProcessMedia() async {
    try {
      final files = await _fileHandler.selectFiles(
        allowedExtensions: ['jpg', 'png', 'jpeg', 'mp4', 'mov', 'mkv'],
      );

      if (files.isEmpty) return;

      await _mediaProcessor.processFiles(
        files: files,
        isProcessing: _isProcessing,
        mediaStatuses: _mediaStatuses,
        context: context,
      );
    } catch (e) {
      ShowError(context, 'Erro ao selecionar ou processar o arquivo: $e');
    }
  }

  Future<void> _processDroppedFiles(List<XFile> xfiles) async {
    try {
      final files = await _fileHandler.convertDroppedFiles(xfiles);

      if (files.isEmpty) return;

      await _mediaProcessor.processFiles(
        files: files,
        isProcessing: _isProcessing,
        mediaStatuses: _mediaStatuses,
        context: context,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ShowError(context, 'Erro ao processar arquivos: $e');
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
      body: DropTarget(
        onDragDone: (details) async {
          await _processDroppedFiles(details.files);
        },
        child: Padding(
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
                          if (isProcessingComplete)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: InkWell(
                                onTap: _selectAndProcessMedia,
                                mouseCursor: SystemMouseCursors.click,
                                child: const Card(
                                  color: Colors.blueGrey,
                                  elevation: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      'Redimensione mais mídias clicando ou arrastando aqui',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: _selectAndProcessMedia,
                              color: Colors.grey,
                              icon: const Icon(
                                  Icons.image_not_supported_rounded,
                                  size: 100),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Nenhuma mídia selecionada',
                              style: TextStyle(fontSize: 18),
                            ),
                            const Text(
                              'Selecione ou arraste arquivos aqui',
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
      ),
    );
  }
}
