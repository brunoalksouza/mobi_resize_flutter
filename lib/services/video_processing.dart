import 'dart:io';
import 'dart:typed_data';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

abstract class VideoProcessingService {
  Future<Uint8List?> processVideo(File file);
}

class VideoProcessor implements VideoProcessingService {
  @override
  Future<Uint8List?> processVideo(File file) async {
    // Caminho para o arquivo de saída
    final String outputPath = '${file.parent.path}/output.mp4';

    // Comando FFmpeg para redimensionar o vídeo
    String command = '-i ${file.path} -vf scale=3240:1080 $outputPath';

    // Executa o comando FFmpeg
    await FFmpegKit.execute(command);

    // Lê o arquivo de saída como bytes
    final File outputFile = File(outputPath);
    if (await outputFile.exists()) {
      return await outputFile.readAsBytes();
    }

    return null;
  }
}
