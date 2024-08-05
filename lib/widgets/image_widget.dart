import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final Uint8List? imageBytes;

  const ImageWidget({required this.imageBytes, super.key});

  @override
  Widget build(BuildContext context) {
    if (imageBytes == null) {
      return const Center(child: Text('Nenhuma imagem selecionada'));
    }

    return Image.memory(
      imageBytes!,
    );
  }
}
