import 'package:mobi_resize_flutter/data/models/user/user_model.dart';

class CurrentUser extends UserModel {
  static CurrentUser? _instance;

  static CurrentUser? get currentUser => _instance;

  String? accountToken;

  CurrentUser._({required UserModel user, this.accountToken})
      : super(
            idDoc: user.idDoc,
            nome: user.nome,
            email: user.email,
            niveis: user.niveis,
            uid: user.uid,
            deleted: user.deleted,
            firstLogin: user.firstLogin,
            idsEmpresas: user.idsEmpresas,
            acessoConsole: user.acessoConsole,
            acessoReportPlus: user.acessoReportPlus,
            acessoPlataformaPlus: user.acessoPlataformaPlus,
            acessoLauncher: user.acessoLauncher,
            acessoStorage: user.acessoStorage,
            acessoIntegrador: user.acessoIntegrador,
            acessoViewer: user.acessoViewer);

  factory CurrentUser(UserModel userModel) {
    if (_instance == null) {
      _instance = CurrentUser._(user: userModel);
    }
    return _instance!;
  }

  get projects => null;

  hardResetUser() => _instance = null;
}
