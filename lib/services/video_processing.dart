import 'dart:io';

import 'package:mobi_resize_flutter/env.dart';

abstract class VideoProcessingService {
  Future<String?> processVideo(File file);
}

class VideoProcessor implements VideoProcessingService {
  @override
  Future<String?> processVideo(File file) async {
    // Caminho do diretório onde o vídeo processado será salvo
    const String directoryPath = caminhoPasta;

    // Verifica se o arquivo de entrada existe
    if (!await file.exists()) {
      return null;
    }

    // Verifica se o diretório de saída existe
    final outputDirectory = Directory(directoryPath);
    if (!await outputDirectory.exists()) {
      // Cria o diretório se ele não existir
      await outputDirectory.create(recursive: true);
    }

    // Caminho para o arquivo de saída
    const String outputPath = '$directoryPath/output.mp4';

    // Caminho completo para o executável do FFmpeg usando caminho relativo
    const String ffmpegPath = 'ffmpeg/bin/ffmpeg.exe';

    // Comando FFmpeg para redimensionar o vídeo
    String command =
        '$ffmpegPath -i "${file.path}" -vf scale=1920:1080 "$outputPath"';

    // Executa o comando FFmpeg usando o processo do sistema no PowerShell
    final result = await Process.run('powershell', ['-Command', command]);

    // Verifica se o comando foi executado com sucesso
    if (result.exitCode == 0) {
      return outputPath; // Retorna o caminho do arquivo processado
    } else {}

    return null;
  }
}
