import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

abstract class ImageProcessingService {
  Future<Uint8List?> processImage(File file);
}

class ImageProcessor implements ImageProcessingService {
  @override
  Future<Uint8List?> processImage(File file) async {
    final Uint8List imageBytes = await file.readAsBytes();
    final ui.Image image = await _loadImage(imageBytes);
    final ui.Image resizedImage = await _resizeImage(image, 5760, 1920);
    return await _encodeImage(resizedImage);
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
}
