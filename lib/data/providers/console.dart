import 'dart:convert';

import 'package:http/http.dart' as http;

class Console{

  static const String BASE_URL = "https://us-central1-accounts-plus.cloudfunctions.net";
  static const String RECOVER_PASS = "/recoveryPassword";


  Future<Map<String, dynamic>> recoverPass(String userEmail) async {

    http.Response _response = await http.post(Uri.parse("$BASE_URL$RECOVER_PASS"), body: {"email":userEmail});

    switch(_response.statusCode){
      case 200:
        return {
          "code": 200,
          "mensagem": "E-mail de recuperação enviado."
        };
      default:
        print(_response.body);
        if (_response.body.contains("RESET_PASSWORD_EXCEED_LIMIT")) {
          return {
            "code": 400,
            "mensagem": "Limite de recuperação de senha excedido. Tente novamente mais tarde ou entre em contato com um administrador."
          };
        }  else if (_response.body.contains("EMAIL_NOT_FOUND")) {
          return {
            "code": 400,
            "mensagem": "E-mail não encontrado."
          };
        }else if(_response.body.contains("The email address is improperly formatted.")){
          return {
            "code": 400,
            "mensagem": "E-mail inválido."
          };
        }else{
          return {
            "code": 400,
            "mensagem": jsonDecode(_response.body)["message"].toString()
          };
        }
    }
  }

}