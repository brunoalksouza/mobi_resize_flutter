import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mobi_resize_flutter/services/get_default_downloads_directory.dart';
import 'package:mobi_resize_flutter/widgets/show_error.dart';
import 'package:path/path.dart' as p;
import 'package:path/path.dart';

abstract class ImageProcessingService {
  Future<String?> processImage(File file);
}

class ImageProcessor implements ImageProcessingService {
  @override
  Future<String?> processImage(File file) async {
    // Lê a imagem como bytes
    final Uint8List imageBytes = await file.readAsBytes();

    // Carrega e redimensiona a imagem
    final ui.Image image = await _loadImage(imageBytes);
    final ui.Image resizedImage = await _resizeImage(image, 1920, 1080);

    // Codifica a imagem redimensionada em bytes
    final Uint8List encodedBytes = await _encodeImage(resizedImage);

    // Salvar a imagem processada e retornar o caminho
    final String outputPath = await _saveImageToDirectory(encodedBytes, file);
    return outputPath;
  }
}

// Carrega a imagem a partir dos bytes
Future<ui.Image> _loadImage(Uint8List imageBytes) async {
  final Completer<ui.Image> completer = Completer();
  ui.decodeImageFromList(imageBytes, (ui.Image image) {
    completer.complete(image);
  });
  return completer.future;
}

// Redimensiona a imagem
Future<ui.Image> _resizeImage(ui.Image image, int width, int height) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(
      recorder,
      Rect.fromPoints(
        const Offset(0, 0),
        Offset(width.toDouble(), height.toDouble()),
      ));

  final paint = Paint()..filterQuality = FilterQuality.high;
  final srcRect =
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
  final dstRect = Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());

  canvas.drawImageRect(image, srcRect, dstRect, paint);

  final picture = recorder.endRecording();
  return await picture.toImage(width, height);
}

// Codifica a imagem redimensionada em formato PNG
Future<Uint8List> _encodeImage(ui.Image image) async {
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

// Método para salvar a imagem na pasta de Downloads
Future<String> _saveImageToDirectory(
    Uint8List imageBytes, File originalFile) async {
  // Obtém o diretório padrão de downloads de acordo com o sistema operacional
  final String? downloadsDirectoryPath = GetDefaultDownloadsDirectory();

  if (downloadsDirectoryPath == null) {
    ShowError(context as BuildContext,
        'Não foi possível encontrar a pasta de Downloads.');
    return '';
  }

  // Verifica se o diretório de saída existe
  final outputDirectory = Directory(downloadsDirectoryPath);
  if (!await outputDirectory.exists()) {
    // Cria o diretório se ele não existir
    await outputDirectory.create(recursive: true);
  }

  // Obtém o nome do arquivo original
  final originalFileName = p.basename(originalFile.path);

  // Caminho para salvar o arquivo na pasta de Downloads
  final String outputPath = p.join(downloadsDirectoryPath, originalFileName);

  // Salva a imagem no diretório
  final File outputFile = File(outputPath);
  await outputFile.writeAsBytes(imageBytes);

  print('Imagem processada e salva em: $outputPath');
  return outputPath;
}
