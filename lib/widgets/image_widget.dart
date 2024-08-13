import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobi_resize_flutter/env.dart';

class ImageWidget extends StatelessWidget {
  final Uint8List? imageBytes;

  ImageWidget({this.imageBytes});

  Future<void> _saveImageToFile(
      BuildContext context, Uint8List imageBytes) async {
    try {
      const directoryPath = caminhoPasta;
      final directoryFile = Directory(directoryPath);

      // Cria o diretório se ele não existir
      if (!await directoryFile.exists()) {
        await directoryFile.create(recursive: true);
      }

      const filePath = '$directoryPath/imagem.png';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagem salva em $filePath')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar a imagem: $e')),
      );
    }
  }

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
              onPressed: () => _saveImageToFile(context, imageBytes!),
              backgroundColor: Colors.blueGrey,
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
