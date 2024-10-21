import 'package:flutter/material.dart';
import 'package:mobi_resize_flutter/utils/colors.dart';

class MobiButton extends StatelessWidget {
  final String? title, imageIconPath;
  final VoidCallback? onTap;
  final Color? buttonColor, textColor, iconColor;
  final bool secondary, isIconButton;
  final double? iconSize, height, width;
  final TextStyle titleStyle;
  final EdgeInsets margin;
  const MobiButton(
      {required this.title,
      this.isIconButton = false,
      this.imageIconPath,
      this.onTap,
      this.buttonColor,
      this.textColor,
      this.secondary = false,
      this.iconSize = 25,
      this.titleStyle = const TextStyle(fontSize: 14, letterSpacing: 1),
      this.width,
      this.height = 35,
      this.iconColor,
      this.margin = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      margin: this.margin,
      height: this.height,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: this.onTap ?? null,
        color: this.secondary
            ? (this.buttonColor ?? secondaryColor)
            : (this.buttonColor ?? primaryColor),
        textColor: this.textColor ?? textColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            this.imageIconPath != null
                ? ImageIcon(
                    AssetImage(this.imageIconPath!),
                    size: this.iconSize,
                    color: this.iconColor,
                  )
                : Container(
                    height: 0,
                    width: 0,
                  ),
            (this.imageIconPath != null && this.title != "")
                ? SizedBox(
                    width: 10,
                  )
                : Container(),
            Text(
              this.title ?? "",
              style: this.titleStyle,
            ),
          ],
        ),
      ),
    );
  }
}
