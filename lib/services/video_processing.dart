import 'dart:io';
import 'package:mobi_resize_flutter/services/get_default_downloads_directory.dart';
import 'package:path/path.dart' as p;
import 'package:mobi_resize_flutter/env.dart'; // Import para outras variáveis que você possa precisar

abstract class VideoProcessingService {
  Future<String?> processVideo(File file);
}

class VideoProcessor implements VideoProcessingService {
  @override
  Future<String?> processVideo(File file) async {
    // Obtém o diretório padrão de downloads de acordo com o sistema operacional
    final String? downloadsDirectoryPath = GetDefaultDownloadsDirectory();

    // Verifica se o caminho da pasta de downloads foi encontrado
    if (downloadsDirectoryPath == null) {
      print('Não foi possível encontrar a pasta de Downloads.');
      return null;
    }

    // Verifica se o arquivo de entrada existe
    if (!await file.exists()) {
      print('Arquivo de vídeo não encontrado.');
      return null;
    }

    // Verifica se o diretório de saída existe
    final outputDirectory = Directory(downloadsDirectoryPath);
    if (!await outputDirectory.exists()) {
      // Cria o diretório de saída se ele não existir
      await outputDirectory.create(recursive: true);
    }

    // Obtém o nome do arquivo original
    final originalFileName = p.basename(file.path);

    // Caminho para o arquivo de saída na pasta de downloads
    final String outputPath = p.join(downloadsDirectoryPath, originalFileName);

    // Caminho completo para o executável do FFmpeg usando caminho relativo
    const String ffmpegPath = 'ffmpeg/bin/ffmpeg.exe';

    // Comando FFmpeg para redimensionar o vídeo
    String command =
        '$ffmpegPath -i "${file.path}" -vf scale=1920:1080 "$outputPath"';

    // Executa o comando FFmpeg usando o processo do sistema no PowerShell (para Windows)
    final result = await Process.run('powershell', ['-Command', command]);

    // Verifica se o comando foi executado com sucesso
    if (result.exitCode == 0) {
      print('Vídeo processado e salvo em: $outputPath');
      return outputPath; // Retorna o caminho do arquivo processado
    } else {
      // Se houver um erro, exibe a mensagem de erro
      print('Erro ao processar vídeo: ${result.stderr}');
      return null;
    }
  }
}
