import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginScreenUI extends StatefulWidget {
  final void Function() onLogin;
  final FirebaseAuth instanceToSignIn;
  final bool showSolicite;
  final String? version;
  final String? channel;

  LoginScreenUI(
      {Key? key,
      this.showSolicite = true,
      required this.instanceToSignIn,
      required this.onLogin,
      this.version,
      this.channel})
      : super(key: key);

  @override
  _LoginScreenUIState createState() => _LoginScreenUIState();
}

class _LoginScreenUIState extends State<LoginScreenUI> {
  GlobalKey<FormState> _key = GlobalKey();
  bool obscure = true;
  bool loading = false;
  bool loadingAuth = true;
  bool continuarLogado = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    setState(() {
      loadingAuth = true;
    });

    await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      widget.onLogin();
    }

    setState(() {
      loadingAuth = false;
    });
  }

  Future<void> onTapSignIn() async {
    if (this._key.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      try {
        UserCredential userCredential =
            await widget.instanceToSignIn.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        widget.onLogin();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro ao fazer login: ${e.toString()}'),
        ));
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loadingAuth) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Form(
                    key: _key,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextFormField(
                          controller: _emailController,
                          onFieldSubmitted: (_) => onTapSignIn(),
                          validator: (text) {
                            if (text!.isNotEmpty) {
                              return null;
                            } else {
                              return "Informe o dado de login";
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "Senha",
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          onFieldSubmitted: (value) => onTapSignIn(),
                          validator: (text) {
                            if (text!.isNotEmpty) {
                              return null;
                            } else {
                              return "Informe a senha";
                            }
                          },
                          obscureText: obscure,
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    obscure = !obscure;
                                  });
                                },
                                child: Icon(
                                  Icons.remove_red_eye,
                                  color: obscure ? Colors.grey : Colors.blue,
                                )),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        CheckboxListTile(
                          title: Text("Continuar logado"),
                          value: continuarLogado,
                          onChanged: (bool? value) {
                            setState(() {
                              continuarLogado = value!;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        Container(
                          child: (loading)
                              ? Center(child: CircularProgressIndicator())
                              : MaterialButton(
                                  onPressed: () => onTapSignIn(),
                                  height: 50,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  color: Colors.blue,
                                  child: Text(
                                    "Confirmar",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        color: Colors.white),
                                  ),
                                ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Esqueceu sua senha? ",
                                style: TextStyle(
                                    fontSize: 14, fontFamily: 'OpenSans'),
                              ),
                              InkWell(
                                onTap: () {
                                  // Implementar a recuperação de senha
                                },
                                child: Text(
                                  "Recupere-a aqui.",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'OpenSans',
                                      color: Colors.blue),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
