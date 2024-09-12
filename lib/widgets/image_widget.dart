import 'dart:typed_data';
import 'dart:io'; // Importação necessária para usar File
import 'package:flutter/material.dart';
import 'package:mobi_resize_flutter/services/save_image_to_directory.dart';

class ImageWidget extends StatelessWidget {
  final Uint8List? imageBytes;
  final File file; // Adiciona o parâmetro file

  ImageWidget({this.imageBytes, required this.file});

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
              onPressed: () => SaveImageToDirectory(context, imageBytes!, file),
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
