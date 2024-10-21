import 'package:flutter/material.dart';
import 'package:mobi_resize_flutter/utils/images.dart';

class LoadingPlus extends StatelessWidget {
  final double height, width;

  const LoadingPlus({Key? key, this.height = 50, this.width = 50})
      : assert(height == width),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: loading == null
                  ? AssetImage("assets/videos/loading_mobi.gif",
                      package: "mobiplus_flutter_ui")
                  : AssetImage(loading!))),
    );
  }
}
