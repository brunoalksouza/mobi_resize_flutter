import 'acesso.dart';

class AcessoStorage implements Acesso {
  @override
  late bool acesso;

  AcessoStorage({this.acesso= false});

  AcessoStorage.fromMap(Map<String, dynamic> map){
    this.acesso = map['acesso'] ?? false;
  }

  @override
  Map<String, dynamic> toMap() =>
      {
        'acesso': this.acesso,
      };
}
