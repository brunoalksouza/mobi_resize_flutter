import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobi_resize_flutter/data/models/enums/projeto.dart';
import 'package:mobi_resize_flutter/data/models/user/current_user.dart';
import 'package:mobi_resize_flutter/pages/login_screen/login_screen_ui.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginScreenUI(
      instanceToSignIn:
          FirebaseAuth.instanceFor(app: Firebase.app("plataforma")),
      onLogin: () {
        if (CurrentUser.currentUser!.firstLogin) {
          Get.offAllNamed("/alterarSenha");
        } else {
          Get.offAllNamed("/empresas");
        }
      },
      projeto: Projeto.PLATAFORMA
    );
  }
}
