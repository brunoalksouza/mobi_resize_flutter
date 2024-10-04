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
      ShowError(context, 'Erro ao processar arquivos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 600,
          // Removed the fixed height
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            shadows: const [
              BoxShadow(
                color: Color.fromARGB(26, 0, 0, 0),
                blurRadius: 72.70,
                offset: Offset(0, 0),
                spreadRadius: 4,
              )
            ],
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Adjusted to take only needed space
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 552,
                child: Text(
                  'Conversor de dimensões de mídia',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                mouseCursor: SystemMouseCursors.click,
                onTap: _selectAndProcessMedia,
                child: Container(
                  width: double.infinity,
                  height: 170,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFFD5D8E2)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file_outlined),
                      SizedBox(height: 16),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Arraste e solte ou ',
                              style: TextStyle(
                                color: Color(0xFF282A37),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: 'escolha o arquivo',
                              style: TextStyle(
                                color: Color(0xFFA9579D),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: ' para fazer upload',
                              style: TextStyle(
                                color: Color(0xFF282A37),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 236,
                        child: Text(
                          'Selecione arquivos mp4, png e jpeg',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Removed Expanded widget to prevent layout issues
              ValueListenableBuilder<List<MediaStatus>>(
                valueListenable: _mediaStatuses,
                builder: (context, mediaStatuses, child) {
                  if (mediaStatuses.isNotEmpty) {
                    double progress = mediaStatuses
                            .where((m) =>
                                m.status == 'Concluído' || m.status == 'Erro')
                            .length /
                        mediaStatuses.length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${mediaStatuses.where((m) => m.status == 'Concluído').length} de ${mediaStatuses.length} mídias concluídas',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 200, // Set a fixed height for the list
                          child: ListView.builder(
                            itemCount: mediaStatuses.length,
                            itemBuilder: (context, index) {
                              final media = mediaStatuses[index];
                              return Card(
                                color: const Color(0xFFF6F7F9),
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: ListTile(
                                  leading: Icon(
                                    media.status == 'Concluído'
                                        ? Icons.check_circle
                                        : media.status == 'Erro'
                                            ? Icons.error
                                            : Icons.access_time,
                                    color: media.status == 'Concluído'
                                        ? Colors.green
                                        : media.status == 'Erro'
                                            ? Colors.red
                                            : const Color(0xFFFF9900),
                                  ),
                                  title: Text(
                                    media.fileName,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        media.status,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      LinearProgressIndicator(
                                          color: media.status == 'Concluído'
                                              ? Colors.green
                                              : media.status == 'Erro'
                                                  ? Colors.red
                                                  : const Color(0xFFFF9900),
                                          value: media.status == 'Concluído'
                                              ? 1
                                              : 0),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox(); // Shows nothing if no status
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
