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
      body: Center(
        child: Container(
          width: 600,
          height: 300,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x11000000),
                blurRadius: 72.70,
                offset: Offset(0, 0),
                spreadRadius: 4,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 552,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Conversor de dimensões de mídia',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 170,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFD5D8E2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(),
                            child: const Icon(Icons.upload_file_outlined),
                          ),
                          const SizedBox(height: 16),
                          const Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Arraste e solte ou ',
                                      style: TextStyle(
                                        color: Color(0xFF282A37),
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'escolha o arquivo',
                                      style: TextStyle(
                                        color: Color(0xFFA9579D),
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' para fazer upload',
                                      style: TextStyle(
                                        color: Color(0xFF282A37),
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 236,
                                child: Text(
                                  'Selecione arquivos mp4, png e jpeg  ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    //       Scaffold(
    //         body: DropTarget(
    //           onDragDone: (details) async {
    //             await _processDroppedFiles(details.files);
    //           },
    //           child: Padding(
    //             padding: const EdgeInsets.all(16.0),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.stretch,
    //               children: [
    //                 ValueListenableBuilder<List<MediaStatus>>(
    //                   valueListenable: _mediaStatuses,
    //                   builder: (context, mediaStatuses, child) {
    //                     bool isProcessingComplete = mediaStatuses.isNotEmpty &&
    //                         mediaStatuses.every((m) =>
    //                             m.status == 'Concluído' || m.status == 'Erro');

    //                     if (mediaStatuses.isNotEmpty) {
    //                       double progress = mediaStatuses
    //                               .where((m) =>
    //                                   m.status == 'Concluído' ||
    //                                   m.status == 'Erro')
    //                               .length /
    //                           mediaStatuses.length;

    //                       return Expanded(
    //                         child: Column(
    //                           children: [
    //                             if (_isProcessing.value)
    //                               LinearProgressIndicator(value: progress),
    //                             Padding(
    //                               padding: const EdgeInsets.all(8.0),
    //                               child: Text(
    //                                 'Processadas: ${mediaStatuses.where((m) => m.status == 'Concluído').length} de ${mediaStatuses.length}',
    //                                 style: const TextStyle(
    //                                     fontSize: 16,
    //                                     fontWeight: FontWeight.w400),
    //                               ),
    //                             ),
    //                             Expanded(
    //                               child: ListView.builder(
    //                                 itemCount: mediaStatuses.length,
    //                                 itemBuilder: (context, index) {
    //                                   final media = mediaStatuses[index];
    //                                   return Card(
    //                                     elevation: 4,
    //                                     margin: const EdgeInsets.symmetric(
    //                                         vertical: 8, horizontal: 16),
    //                                     child: ListTile(
    //                                       leading: Icon(
    //                                         media.status == 'Concluído'
    //                                             ? Icons.check_circle
    //                                             : media.status == 'Erro'
    //                                                 ? Icons.error
    //                                                 : Icons.hourglass_empty,
    //                                         color: media.status == 'Concluído'
    //                                             ? Colors.green
    //                                             : media.status == 'Erro'
    //                                                 ? Colors.red
    //                                                 : Colors.orange,
    //                                       ),
    //                                       title: Text(media.fileName),
    //                                       subtitle:
    //                                           Text('Status: ${media.status}'),
    //                                     ),
    //                                   );
    //                                 },
    //                               ),
    //                             ),
    //                             if (isProcessingComplete)
    //                               Padding(
    //                                 padding: const EdgeInsets.symmetric(
    //                                     vertical: 16.0),
    //                                 child: InkWell(
    //                                   onTap: _selectAndProcessMedia,
    //                                   mouseCursor: SystemMouseCursors.click,
    //                                   child: const Card(
    //                                     color: Colors.blueGrey,
    //                                     elevation: 2,
    //                                     child: Padding(
    //                                       padding: EdgeInsets.all(16.0),
    //                                       child: Text(
    //                                         'Redimensione mais mídias clicando ou arrastando aqui',
    //                                         style: TextStyle(
    //                                           fontSize: 18,
    //                                           color: Colors.white,
    //                                         ),
    //                                         textAlign: TextAlign.center,
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ),
    //                           ],
    //                         ),
    //                       );
    //                     } else {
    //                       return Expanded(
    //                         child: Center(
    //                           child: Column(
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             children: [
    //                               IconButton(
    //                                 onPressed: _selectAndProcessMedia,
    //                                 color: Colors.grey,
    //                                 icon: const Icon(
    //                                     Icons.image_not_supported_rounded,
    //                                     size: 100),
    //                               ),
    //                               const SizedBox(height: 20),
    //                               const Text(
    //                                 'Nenhuma mídia selecionada',
    //                                 style: TextStyle(fontSize: 18),
    //                               ),
    //                               const Text(
    //                                 'Selecione ou arraste arquivos aqui',
    //                                 style: TextStyle(fontSize: 18),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       );
    //                     }
    //                   },
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
