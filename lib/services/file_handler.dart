// file_handler.dart

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:cross_file/cross_file.dart';

class FileHandler {
  Future<List<File>> selectFiles({List<String>? allowedExtensions}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      allowMultiple: true,
    );

    if (result == null || result.files.isEmpty) return [];

    // Convert PlatformFile to File
    return result.files
        .where((file) => file.path != null)
        .map((file) => File(file.path!))
        .toList();
  }

  Future<List<File>> convertDroppedFiles(List<XFile> xfiles) async {
    return xfiles
        .where((xfile) => xfile.path.isNotEmpty)
        .map((xfile) => File(xfile.path))
        .toList();
  }
}
