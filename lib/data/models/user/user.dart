class User {
  String? nome, email, uid, nivel, id;
  bool? firstLogin;
  List<String>? lancamentos;
  List<dynamic>? idsEmpresas;

  User(
      {this.nome,
      this.email,
      this.uid,
      this.nivel,
      this.lancamentos,
      this.id,
      this.idsEmpresas,
      this.firstLogin = false});

  User.fromJson(Map<dynamic, dynamic> json) {
    email = json["email"];
    nome = json["nome"];
    uid = json["uid"];
    nivel = json["nivel"];
    id = json["id"];
    idsEmpresas = json["idsEmpresas"];
    firstLogin = json["firstLogin"] ?? false;
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "nome": nome,
        'uid': uid,
        "nivel": nivel,
        "id": id,
        "idsEmpresas": idsEmpresas,
        "firstLogin": firstLogin
      };
}
