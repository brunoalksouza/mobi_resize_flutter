import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuthProvider
    hide AuthProvider; // Dê um prefixo aqui
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobi_resize_flutter/data/models/user/current_user.dart';
import 'package:mobi_resize_flutter/data/models/user/user_model.dart';
import 'package:mobi_resize_flutter/data/providers/auth_provider.dart'
    as customAuthProvider;
import 'package:mobi_resize_flutter/data/providers/user_provider.dart';
import 'package:mobi_resize_flutter/utils/colors.dart';
import 'package:mobi_resize_flutter/widgets/loading_plus/loading_plus.dart';
import 'package:mobi_resize_flutter/widgets/mobi_button/mobi_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobi_resize_flutter/data/providers/console.dart';
import 'package:mobi_resize_flutter/widgets/mobi_alerts/mobi_error.dart';
import 'package:mobi_resize_flutter/widgets/mobi_alerts/mobi_success.dart';
import '../../../data/models/enums/projeto.dart';
import '../../../firebase_options.dart';

class LoginScreenController extends GetxController {
  static const String stringAccountsToken = "accountsToken";
  final emailController = TextEditingController(),
      passwordController = TextEditingController();

  TextEditingController _emailRecoverController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  Console _console = Console();
  RxBool loading = false.obs;

  Future<void> recoverPass(String email, BuildContext context) async {
    Map<String, dynamic> _response = await _console.recoverPass(email);
    if (_response["code"] == 200) {
      showDialog(
          context: context,
          builder: (context) => MobiSuccess(
                mensagem: _response["mensagem"].toString(),
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => MobiError(
                mensagem: _response["mensagem"].toString(),
              ));
    }
    this.loading.value = false;
  }

  Future<void> setup(
      {required firebaseAuthProvider.FirebaseAuth instance,
      required VoidCallback onLogin,
      required Projeto projeto,
      required VoidCallback onFinish}) async {
    await initializeFirebase();
    User? _user = firebaseAuthProvider.FirebaseAuth.instanceFor(
            app: Firebase.app("accounts"))
        .currentUser;
    if (_user == null)
      _user = await firebaseAuthProvider.FirebaseAuth.instanceFor(
              app: Firebase.app("accounts"))
          .authStateChanges()
          .first;
    if (_user != null) {
      await initializeCurrentUser();
      onLogin();
    } else {
      final _persist = await getPersist();
      if (_persist != null && _persist) {
        final _token = await getToken();
        if (_token != null && _token.isNotEmpty) {
          await handleSignIn(
              token: _token,
              instanceExternal: instance,
              onLogin: onLogin,
              projeto: projeto,
              persist: true,
              onFinish: onFinish);
        }
      } else {
        onFinish();
      }
    }
  }

  Future<void> initUsersDeleted() async {
    await UserProvider.createDeletedField();
  }

  Future<void> initializeCurrentUser() async {
    try {
      UserModel? _user = await UserProvider.get(
          uid: customAuthProvider.AuthProvider.checkCurrentUser()!.uid);
      CurrentUser(_user);
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        name: "accounts",
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      print(e);
    }
  }

  void onTapRecover(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          MobiButton(
            title: "Cancelar",
            buttonColor: Colors.white,
            textColor: Colors.black,
            onTap: () => Navigator.pop(context),
          ),
          Obx(() {
            if (this.loading.value) {
              return LoadingPlus();
            } else {
              return MobiButton(
                  title: "Solicitar",
                  onTap: () async {
                    if (this._key.currentState!.validate()) {
                      this.loading.value = true;
                      await this.recoverPass(
                          this._emailRecoverController.text, context);
                    }
                  });
            }
          })
        ],
        content: Container(
          padding: EdgeInsets.all(10.0),
          width: 400,
          constraints: BoxConstraints(minWidth: 300, maxWidth: 400),
          child: Form(
            key: this._key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          child: ImageIcon(
                            AssetImage('assets/images/icon_back.png',
                                package: "mobiplus_flutter_ui"),
                            color: Colors.black,
                            size: 25.0,
                          ),
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          child: Text(
                            "Recuperar senha",
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Divider(
                          height: 2,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    "E-mail",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                TextFormField(
                  controller: this._emailRecoverController,
                  validator: (value) {
                    if (value!.isEmpty) return "Informe um e-mail";
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Função para salvar e obter tokens no lugar de cookies usando SharedPreferences
  Future<void> setPersist(String token, bool persist) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setBool('persist', persist);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<bool?> getPersist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('persist');
  }

  Future<void> handleSignIn(
      {required firebaseAuthProvider.FirebaseAuth instanceExternal,
      required VoidCallback onLogin,
      VoidCallback? onFinish,
      Projeto? projeto,
      String? token,
      bool persist = false}) async {
    try {
      print("Iniciou login no accounts");
      await signIn(
          firebaseAuth: firebaseAuthProvider.FirebaseAuth.instanceFor(
              app: Firebase.app("accounts")),
          token: token,
          persist: persist);
      print('fez login no accounts');
      final String accountToken =
          await customAuthProvider.AuthProvider.getToken(
              CurrentUser.currentUser!.uid!, null);
      print("Pegou o token do accounts");
      await setPersist(accountToken, persist);
      if (hasAccess(projeto: projeto)) {
        print("Tem acesso ao $projeto");
        final String tokenProjeto =
            await customAuthProvider.AuthProvider.getToken(
                CurrentUser.currentUser!.uid!, projeto);
        print("Pegou o token do $projeto");
        await signIn(
            firebaseAuth: instanceExternal,
            projeto: projeto,
            token: tokenProjeto,
            persist: persist);
        print("Fez o signin no $projeto via TOKEN");
        onLogin();
      } else {
        await clearPersist();
        await customAuthProvider.AuthProvider.signOut();
        if (CurrentUser.currentUser != null)
          CurrentUser.currentUser!.hardResetUser();
        Get.dialog(MobiError(
          mensagem:
              "Ops! Você não possui permissão para acessar este sistema!\nSe acredita que isso é um erro, entre em contato com o suporte!",
        ));
      }
    } on Exception catch (e) {
      print(e.toString());
      switch (e.toString()) {
        case "Exception: Um erro inesperado ocorreu!":
          await clearPersist();
          onFinish!();
          break;
        default:
          break;
      }
    }
  }

  Future<void> signIn(
      {required firebaseAuthProvider.FirebaseAuth firebaseAuth,
      String? token,
      bool persist = false,
      Projeto? projeto}) async {
    await firebaseAuth.signInWithCustomToken(token!);
  }

  bool hasAccess({required Projeto? projeto}) {
    return CurrentUser.currentUser!.projects!.contains(projeto);
  }

  Future<void> clearPersist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('persist');
  }
}
