import 'acesso.dart';

class AcessoIntegrador implements Acesso {
  @override
  late bool acesso;

  late bool acessoRoot;

  AcessoIntegrador({this.acesso= false});

  AcessoIntegrador.fromMap(Map<String, dynamic> map){
    this.acesso = map['acesso'] ?? false;
  }

  @override
  Map<String, dynamic> toMap() =>
      {
        'acesso': this.acesso,
      };
}