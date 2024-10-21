import 'acesso.dart';

class AcessoReportPlus implements Acesso {

  @override
  late bool acesso;

  late bool agrupamentoSee,
      allLancamentoSee,
      allProjetoSee,
      estoqueAdmin,
      estoqueSee,
      financeiroSee,
      forumAdd,
      forumSee,
      lancamentoAdd,
      lancamentoSee,
      produtoAdd,
      produtoSee,
      projetoAdmin,
      projetoSee,
      userSee;

  AcessoReportPlus({
    this.acesso= false,
    this.agrupamentoSee= false,
    this.allLancamentoSee= false,
    this.allProjetoSee= false,
    this.estoqueAdmin= false,
    this.estoqueSee= false,
    this.financeiroSee= false,
    this.forumAdd= false,
    this.forumSee= false,
    this.lancamentoAdd= false,
    this.lancamentoSee= false,
    this.produtoAdd= false,
    this.produtoSee= false,
    this.projetoAdmin= false,
    this.projetoSee= false,
    this.userSee= false,
  });

  AcessoReportPlus.fromMap(Map<String, dynamic> map){
    acesso = map['acesso'] ?? false;
    agrupamentoSee = map['agrupamentoSee'] ?? false;
    allLancamentoSee = map['allLancamentoSee'] ?? false;
    allProjetoSee = map['allProjetoSee'] ?? false;
    estoqueAdmin = map['estoqueAdmin'] ?? false;
    estoqueSee = map['estoqueSee'] ?? false;
    financeiroSee = map['financeiroSee'] ?? false;
    forumAdd = map['forumAdd'] ?? false;
    forumSee = map['forumSee'] ?? false;
    lancamentoAdd = map['lancamentoAdd'] ?? false;
    lancamentoSee = map['lancamentoSee'] ?? false;
    produtoAdd = map['produtoAdd'] ?? false;
    produtoSee = map['produtoSee'] ?? false;
    projetoAdmin = map['projetoAdmin'] ?? false;
    projetoSee = map['projetoSee'] ?? false;
    userSee = map['userSee'] ?? false;
  }

  @override
  Map<String, dynamic> toMap() =>
      {
        "acesso": this.acesso,
        "agrupamentoSee": this.agrupamentoSee,
        "allLancamentoSee": this.allLancamentoSee,
        "allProjetoSee": this.allProjetoSee,
        "estoqueAdmin": this.estoqueAdmin,
        "estoqueSee": this.estoqueSee,
        "financeiroSee": this.financeiroSee,
        "forumAdd": this.forumAdd,
        "forumSee": this.forumSee,
        "lancamentoAdd": this.lancamentoAdd,
        "lancamentoSee": this.lancamentoSee,
        "produtoAdd": this.produtoAdd,
        "produtoSee": this.produtoSee,
        "projetoAdmin": this.projetoAdmin,
        "projetoSee": this.projetoSee,
        "userSee": this.userSee,
      };
}
