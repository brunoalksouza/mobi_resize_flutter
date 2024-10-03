// media_processor.dart

import 'dart:io';
import 'package:mobi_resize_flutter/models/media_status.dart';
import 'package:mobi_resize_flutter/widgets/show_error.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:mobi_resize_flutter/services/image_processing.dart';
import 'package:mobi_resize_flutter/services/video_processing.dart';

class MediaProcessor {
  final ImageProcessingService imageProcessor;
  final VideoProcessingService videoProcessor;

  MediaProcessor({
    required this.imageProcessor,
    required this.videoProcessor,
  });

  Future<void> processFiles({
    required List<File> files,
    required ValueNotifier<bool> isProcessing,
    required ValueNotifier<List<MediaStatus>> mediaStatuses,
    required BuildContext context,
  }) async {
    try {
      isProcessing.value = true;

      // Create new MediaStatus for each file
      final newMediaStatuses = files.map((file) {
        return MediaStatus(fileName: p.basename(file.path));
      }).toList();

      // Combine existing MediaStatuses with the new ones
      mediaStatuses.value = [...mediaStatuses.value, ...newMediaStatuses];

      // Process each file
      for (int i = mediaStatuses.value.length - newMediaStatuses.length;
          i < mediaStatuses.value.length;
          i++) {
        final file =
            files[i - (mediaStatuses.value.length - newMediaStatuses.length)];

        // Update status to 'Processing...'
        mediaStatuses.value[i].status = 'Processando...';
        mediaStatuses.value = List.from(mediaStatuses.value);

        String? outputPath;
        final extension = p.extension(file.path).toLowerCase();

        if (_isVideoFile(extension)) {
          outputPath = await videoProcessor.processVideo(file);
        } else {
          outputPath = await imageProcessor.processImage(file);
        }

        // Update status to 'Concluído' or 'Erro'
        mediaStatuses.value[i].status =
            outputPath != null ? 'Concluído' : 'Erro';
        mediaStatuses.value = List.from(mediaStatuses.value);
      }
    } catch (e) {
      ShowError(context, 'Erro ao processar arquivos: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  bool _isVideoFile(String? extension) {
    return ['.mp4', '.mov', '.mkv'].contains(extension?.toLowerCase());
  }
}
