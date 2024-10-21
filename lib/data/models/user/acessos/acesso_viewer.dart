import 'acesso.dart';

class AcessoViewer implements Acesso {
  @override
  late bool acesso;

  AcessoViewer({this.acesso = false});

  AcessoViewer.fromMap(Map<String, dynamic> map){
    this.acesso = map['acesso'] ?? false;
  }

  @override
  Map<String, dynamic> toMap() =>
      {
        'acesso': this.acesso,
      };
}