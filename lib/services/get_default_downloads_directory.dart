// ignore: non_constant_identifier_names
import 'dart:io';
import 'package:path/path.dart' as p;

String? GetDefaultDownloadsDirectory() {
  if (Platform.isWindows) {
    return Platform.environment['USERPROFILE'] != null
        ? p.join(Platform.environment['USERPROFILE']!, 'Downloads')
        : null;
  } else if (Platform.isMacOS || Platform.isLinux) {
    return Platform.environment['HOME'] != null
        ? p.join(Platform.environment['HOME']!, 'Downloads')
        : null;
  }
  return null;
}
