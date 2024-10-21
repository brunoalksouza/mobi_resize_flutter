import 'package:mobi_resize_flutter/data/models/user/acessos/acesso_integrador.dart';
import 'package:mobi_resize_flutter/data/models/user/acessos/acesso_viewer.dart';

import '../enums/projeto.dart';
import 'acessos/acesso_console.dart';
import 'acessos/acesso_launcher.dart';
import 'acessos/acesso_plataforma_plus.dart';
import 'acessos/acesso_report_plus.dart';
import 'acessos/acesso_storage.dart';

class UserModel {
  List<dynamic> idsEmpresas;
  String? nome, email, uid, idDoc;
  bool deleted;
  late Map<String, dynamic> niveis;
  late bool firstLogin;
  late AcessoConsole acessoConsole;
  late AcessoReportPlus acessoReportPlus;
  late AcessoPlataformaPlus acessoPlataformaPlus;
  late AcessoLauncher acessoLauncher;
  late AcessoStorage acessoStorage;
  late AcessoViewer acessoViewer;
  late AcessoIntegrador acessoIntegrador;

  UserModel(
      {this.idDoc,
      this.nome,
      this.email,
      required this.niveis,
      this.uid,
      this.deleted = false,
      required this.firstLogin,
      this.idsEmpresas = const [],
      required this.acessoConsole,
      required this.acessoReportPlus,
      required this.acessoPlataformaPlus,
      required this.acessoLauncher,
      required this.acessoStorage,
      required this.acessoViewer,
      required this.acessoIntegrador});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      nome: map['nome'],
      email: map['email'],
      niveis: (map['niveis'] as Map<String, dynamic>),
      uid: map['uid'],
      idDoc: map['idDoc'],
      deleted: map['deleted'] != null ? map['deleted'] : true,
      firstLogin: map['firstLogin'],
      idsEmpresas: map['idsEmpresas'] ?? <String>[],
      acessoConsole:
          AcessoConsole.fromMap(map['acessoConsole'] ?? <String, dynamic>{}),
      acessoReportPlus: AcessoReportPlus.fromMap(
          map['acessoReportPlus'] ?? <String, dynamic>{}),
      acessoPlataformaPlus: AcessoPlataformaPlus.fromMap(
          map['acessoPlataformaPlus'] ?? <String, dynamic>{}),
      acessoStorage:
          AcessoStorage.fromMap(map['acessoStorage'] ?? <String, dynamic>{}),
      acessoLauncher:
          AcessoLauncher.fromMap(map['acessoLauncher'] ?? <String, dynamic>{}),
      acessoViewer:
          AcessoViewer.fromMap(map['acessoViewer'] ?? <String, dynamic>{}),
      acessoIntegrador: AcessoIntegrador.fromMap(
          map['acessoIntegrador'] ?? <String, dynamic>{}),
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'idDoc': idDoc,
        'nome': nome,
        'email': email,
        'deleted': deleted,
        'niveis': niveis,
        'firstLogin': firstLogin,
        'idsEmpresas': idsEmpresas,
        'acessoConsole': acessoConsole.toMap(),
        'acessoReportPlus': acessoReportPlus.toMap(),
        'acessoPlataformaPlus': acessoPlataformaPlus.toMap(),
        'acessoStorage': acessoStorage.toMap(),
        'acessoLauncher': acessoLauncher.toMap(),
        'acessoViewer': acessoStorage.toMap(),
        'acessoIntegrador': acessoIntegrador.toMap(),
      };

  bool hasAcesso(Projeto? projeto) {
    if (deleted) return false;
    switch (projeto) {
      case Projeto.CONSOLE:
        return acessoConsole.acesso;
      case Projeto.PLATAFORMA:
        return acessoPlataformaPlus.acesso;
      case Projeto.REPORT:
        return acessoReportPlus.acesso;
      case Projeto.STORAGE:
        return acessoStorage.acesso;
      case Projeto.LAUNCHER:
        return acessoLauncher.acesso;
      case Projeto.VIEWER:
        return acessoViewer.acesso;
      case Projeto.INTEGRADOR:
        return acessoIntegrador.acesso;
      default:
        return false;
    }
  }
}
