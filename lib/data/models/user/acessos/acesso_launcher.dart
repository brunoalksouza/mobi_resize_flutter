import 'acesso.dart';

class AcessoLauncher implements Acesso {
  @override
  late bool acesso;

  AcessoLauncher({this.acesso= false});

  AcessoLauncher.fromMap(Map<String, dynamic> map){
    this.acesso = map['acesso'] ?? false;
  }

  @override
  Map<String, dynamic> toMap() =>
      {
        'acesso': this.acesso,
      };
}
