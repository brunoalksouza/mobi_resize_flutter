import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobi_resize_flutter/data/models/enums/projeto.dart';
import 'package:mobi_resize_flutter/data/models/user/current_user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider {
  static FirebaseAuth _auth =
      FirebaseAuth.instanceFor(app: Firebase.app("accounts"));

  static Future<void> signIn(
      String email, String password, FirebaseAuth auth) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<void> alterarSenha(String senhaAtual, String novaSenha) async {
    bool _isValidPass = await _verificarSenha(senhaAtual);
    if (_isValidPass) {
      await _auth.currentUser!.updatePassword(novaSenha);
    }
  }

  static Future<bool> _verificarSenha(String password) async {
    AuthCredential _authCredential = EmailAuthProvider.credential(
        email: CurrentUser.currentUser!.email!, password: password);
    UserCredential _authResult =
        await _auth.currentUser!.reauthenticateWithCredential(_authCredential);
    return _authResult.user != null;
  }

  static Future<void> signOut() async {
    try {
      CurrentUser.currentUser!.hardResetUser();
      await clearPersist(); // Substituir cookies
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  static Future<void> signInWithToken(FirebaseAuth auth, String token,
      {Persistence persistence = Persistence.NONE}) async {
    try {
      await auth.setPersistence(persistence);
      await auth.signInWithCustomToken(token);
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(
          "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    }
  }

  static Future<String> getToken(String uid, Projeto? projeto) async {
    try {
      final String url = projeto == null
          ? "https://us-central1-accounts-plus.cloudfunctions.net/generateCustomToken"
          : "https://us-central1-accounts-plus.cloudfunctions.net/getCustomToken";
      final http.Response response = await http.post(Uri.parse(url), body: {
        "uid": uid,
        "projeto": projeto?.name ?? "ACCOUNTS" //pode ser null
      });
      return jsonDecode(response.body)['token'];
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<bool> signUpOther(
      String email, String password, Projeto projeto) async {
    print({
      "uid": CurrentUser.currentUser!.uid,
      "email": email,
      "password": password,
      "projeto": projeto.name
    });
    http.Response response = await http.post(
        Uri.parse(
            "https://us-central1-accounts-plus.cloudfunctions.net/signUpOther"),
        body: {
          "uid": CurrentUser.currentUser!.uid,
          "email": email,
          "password": password,
          "projeto": projeto.name
        });

    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }

  static User? checkCurrentUser() {
    return _auth.currentUser;
  }

  /// Funções para persistir dados usando SharedPreferences
  static Future<void> setPersist(String token, bool persist) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setBool('persist', persist);
  }

  static Future<String?> getPersistedToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<bool?> getPersist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('persist');
  }

  static Future<void> clearPersist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
