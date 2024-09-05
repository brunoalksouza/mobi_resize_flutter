import 'dart:io';
import 'dart:typed_data';

abstract class VideoProcessingService {
  Future<Uint8List?> processVideo(File file);
}

class VideoProcessor implements VideoProcessingService {
  @override
  Future<Uint8List?> processVideo(File file) async {
    // Verifique se o arquivo de entrada existe
    if (!await file.exists()) {
      print('Arquivo de entrada não encontrado: ${file.path}');
      return null;
    }

    // Caminho para o arquivo de saída
    final String outputPath = '${file.parent.path}/output.mp4';

    // Caminho completo para o executável do FFmpeg usando caminho relativo
    const String ffmpegPath = 'ffmpeg/bin/ffmpeg.exe';

    // Comando FFmpeg para redimensionar o vídeo
    String command =
        '$ffmpegPath -i "${file.path}" -vf scale=5760:1920 "$outputPath"';

    // Executa o comando FFmpeg usando o processo do sistema no PowerShell
    final result = await Process.run(
      'powershell',
      ['-Command', command],
    );

    // Verifique se o comando foi executado com sucesso
    if (result.exitCode == 0) {
      // Lê o arquivo de saída como bytes
      final File outputFile = File(outputPath);
      if (await outputFile.exists()) {
        print('Processamento de vídeo concluído com sucesso.');
        return await outputFile.readAsBytes();
      }
    } else {
      // Exibe o erro se o comando falhar
      print('Erro ao processar vídeo: ${result.stderr}');
    }

    return null;
  }
}
