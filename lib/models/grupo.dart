class Grupo {
  String? id, descricao, orientacao;
  List<dynamic>? data;
  String? definicaoId;
  bool? deleted, chamadorPlus;
  int? version;
  bool locked;

  Grupo({
    this.id,
    this.descricao,
    this.data,
    this.deleted = false,
    this.version = 0,
    this.orientacao,
    this.definicaoId,
    this.locked = false,
    this.chamadorPlus,
  });

  Grupo copyWith({
    String? id,
    String? descricao,
    String? orientacao,
    List<dynamic>? data,
    String? definicaoId,
    bool? deleted,
    int? version,
    bool? locked,
  }) {
    return Grupo(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
      data: data ?? this.data,
      deleted: deleted ?? this.deleted,
      orientacao: orientacao ?? this.orientacao,
      definicaoId: definicaoId ?? this.definicaoId,
      version: version ?? this.version,
      locked: locked ?? this.locked,
    );
  }

  Grupo updateWith({
    String? descricao,
    String? orientacao,
    String? definicaoId,
    List? data,
    bool? locked,
  }) {
    return Grupo(
      id: this.id,
      descricao: descricao ?? this.descricao,
      data: data ?? this.data,
      deleted: this.deleted,
      orientacao: orientacao ?? this.orientacao,
      definicaoId: definicaoId ?? this.definicaoId,
      locked: locked ?? this.locked,
      version: this.version == null ? 1 : this.version = this.version! + 1,
    );
  }

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      chamadorPlus: json['chamadorPlus'],
      descricao: json['descricao'] ?? '',
      id: json['id'],
      definicaoId: json['definicao'] != null
          ? json['definicao'].runtimeType != String
              ? json['definicao']['id']
              : json['definicao']
          : null,
      data: json['data'],
      deleted: json['deleted'] ?? false,
      version: json["version"] ?? 0,
      orientacao: getOrientacao(json["orientacao"]),
      locked: json['locked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'definicao': this.definicaoId,
        'descricao': this.descricao,
        'id': this.id,
        'data': this.data,
        'deleted': this.deleted,
        'version': this.version ?? 0,
        'orientacao': this.orientacao,
      };

  static String getOrientacao(String? orientacao) {
    switch (orientacao) {
      case 'horizontal':
        return 'Televisão Horizontal';
      case 'vertical':
        return 'Televisão Vertical';
      case 'Terminal de Consulta':
        return 'ck100';
      case 'totem':
        return 'totem';
      default:
        return 'Televisão Horizontal';
    }
  }
}
