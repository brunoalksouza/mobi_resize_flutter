import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobi_resize_flutter/env.dart';
import 'package:path/path.dart' as p;

void SaveImageToDirectory(
    BuildContext context, Uint8List imageBytes, File file) async {
  try {
    const directoryPath = caminhoPasta;
    final directoryFile = Directory(directoryPath);

    // Cria o diretório se ele não existir
    if (!await directoryFile.exists()) {
      await directoryFile.create(recursive: true);
    }

    final originalFileName = p.basename(file.path);

    final filePath = '$directoryPath/$originalFileName';

    final newFile = File(filePath);
    await newFile.writeAsBytes(imageBytes);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mídia salva em $filePath')),
    );
  } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao salvar a imagem: $e')),
    );
  }
}
