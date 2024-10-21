import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../mobi_button/mobi_button.dart';

class MobiDialog extends StatelessWidget {
  final String title, titleCancel, titleSubmit;
  final List<Widget> body;

  final bool showCancel, showSubmit;
  final double width;
  final VoidCallback? onPressBack, onPressSubmit, onPressCancel;
  const MobiDialog(
      {Key? key,
        required this.title,
        required this.body,
        this.onPressBack,
        this.onPressSubmit,
        this.onPressCancel,
        this.showCancel = true,
        this.showSubmit = true,
        this.titleCancel = "Cancelar",
        this.titleSubmit = "Salvar", this.width = 550})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        this.showCancel ? MobiButton(
          buttonColor: Colors.white,
          textColor: Colors.black,
          title: this.titleCancel,
          onTap: this.onPressCancel,
        ) : Container(),
        this.showSubmit ? MobiButton(
          title: this.titleSubmit,
          onTap: this.onPressSubmit,
        ) : Container(),
      ],
      content: Container(
        padding: EdgeInsets.all(10.0),
        width: width,
        constraints: BoxConstraints(minWidth: 550, maxWidth: 1050),
        //INICIO DO FORMULARIO
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        child: ImageIcon(
                          AssetImage('web/assets/icons/icon_back.png'),
                          color: Colors.black,
                          size: 25.0,
                        ),
                        onTap: this.onPressBack,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        child: Text(
                          this.title,
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Divider(
                        height: 2,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              //LINHA DESCRICAO

              ...body
            ],
          ),
        ),
      ),
    );
  }
}
