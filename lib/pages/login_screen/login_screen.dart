import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobi_resize_flutter/main.dart';
import 'package:mobi_resize_flutter/pages/login_screen/login_screen_ui.dart';
import 'package:mobi_resize_flutter/pages/media_picker_screen.dart';
import 'package:mobi_resize_flutter/services/image_processing.dart';
import 'package:mobi_resize_flutter/services/video_processing.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginScreenUI(
      instanceToSignIn:
          FirebaseAuth.instanceFor(app: Firebase.app("plataforma")),
      onLogin: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => MediaPickerScreen(
                      imageProcessor: ImageProcessor(),
                      videoProcessor: VideoProcessor(),
                    )));
      },
    );
  }
}
