import 'dart:io';
import 'dart:typed_data';

abstract class VideoProcessingService {
  Future<Uint8List?> processVideo(File file);
}

class VideoProcessor implements VideoProcessingService {
  @override
  Future<Uint8List?> processVideo(File file) async {
    final Uint8List imageBytes = await file.readAsBytes();
  }
}
