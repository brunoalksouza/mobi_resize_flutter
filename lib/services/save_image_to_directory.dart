import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobi_resize_flutter/env.dart';

void SaveImageToDirectory(BuildContext context, Uint8List imageBytes) async {
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
      const SnackBar(content: Text('Mídia salva em $filePath')),
    );
  } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao salvar a imagem: $e')),
    );
  }
}
