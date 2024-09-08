import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobi_resize_flutter/services/save_to_directory.dart';

class ImageWidget extends StatelessWidget {
  final Uint8List? imageBytes;

  ImageWidget({this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        imageBytes == null
            ? const Center(child: Text('Nenhuma imagem selecionada.'))
            : Image.memory(imageBytes!),
        if (imageBytes != null)
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: () => SaveToDirectory(context, imageBytes!),
              backgroundColor: Colors.blueGrey,
              tooltip: 'Download',
              child: const Icon(
                Icons.download,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
