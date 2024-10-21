import 'package:flutter/material.dart';
import 'package:mobi_resize_flutter/utils/colors.dart';
import 'package:mobi_resize_flutter/widgets/mobi_button/mobi_button.dart';

class MobiError extends StatelessWidget {
  final String? mensagem;

  const MobiError({Key? key, this.mensagem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        MobiButton(title: "Ok", onTap: () => Navigator.pop(context)),
      ],
      content: Container(
        padding: EdgeInsets.all(10.0),
        width: 400,
        constraints: BoxConstraints(minWidth: 300, maxWidth: 400),
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
                        AssetImage('assets/images/icon_back.png',
                            package: "mobiplus_flutter_ui"),
                        color: Colors.black,
                        size: 25.0,
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "Erro!",
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Icon(
                            Icons.cancel_outlined,
                            color: Colors.deepOrange,
                            size: 30,
                          ),
                        )
                      ],
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
            Container(
              margin: EdgeInsets.only(bottom: 5.0),
              child: Text(
                mensagem!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
