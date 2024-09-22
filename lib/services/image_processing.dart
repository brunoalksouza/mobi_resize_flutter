import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:path/path.dart' as p;
import 'package:mobi_resize_flutter/env.dart';

abstract class ImageProcessingService {
  Future<String?> processImage(File file);
}

class ImageProcessor implements ImageProcessingService {
  @override
  Future<String?> processImage(File file) async {
    final Uint8List imageBytes = await file.readAsBytes();
    final ui.Image image = await _loadImage(imageBytes);
    final ui.Image resizedImage = await _resizeImage(image, 1920, 1080);
    final Uint8List encodedBytes = await _encodeImage(resizedImage);

    // Salvar a imagem processada e retornar o caminho
    final String outputPath = await _saveImageToDirectory(encodedBytes, file);
    return outputPath;
  }
}

Future<ui.Image> _loadImage(Uint8List imageBytes) async {
  final Completer<ui.Image> completer = Completer();
  ui.decodeImageFromList(imageBytes, (ui.Image image) {
    completer.complete(image);
  });
  return completer.future;
}

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

Future<Uint8List> _encodeImage(ui.Image image) async {
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

Future<String> _saveImageToDirectory(
    Uint8List imageBytes, File originalFile) async {
  // Obtém o diretório onde o arquivo original está localizado

  const String directoryPath = caminhoPasta;
  final originalFileName = p.basename(originalFile.path);

  final String outputPath = '$directoryPath/$originalFileName';
  final File outputFile = File(outputPath);
  await outputFile.writeAsBytes(imageBytes);
  return outputPath;
}
