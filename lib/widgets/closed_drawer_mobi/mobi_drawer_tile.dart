import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobi_resize_flutter/utils/colors.dart';
import 'package:mobi_resize_flutter/utils/resources.dart';

class MobiDrawerTile extends StatelessWidget {
  final _tileController = Get.find<ResourcesController>();

  final String? title;
  final String? imageIcon;
  final IconData? icon;
  final int uniqueId;
  final VoidCallback? onTap;
  final bool selectable;

  MobiDrawerTile(
      {Key? key,
      this.title,
      required this.uniqueId,
      this.onTap,
      this.imageIcon,
      this.icon,
      this.selectable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: _tileController,
        builder: (dynamic context) {
          return InkWell(
            onTap: () {
              if (this.selectable) {
                _tileController.setDrawerIndex(uniqueId);
              }
              if (this.onTap != null) {
                this.onTap!.call();
              }
            },
            child: Container(
              height: kToolbarHeight - 10,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 23),
                      child: this.icon != null
                          ? Icon(icon,
                              color: _tileController.drawerIndex == uniqueId
                                  ? Color(accentMenuColor.value)
                                  : primaryMenuColor)
                          : ImageIcon(
                              AssetImage(this.imageIcon!),
                              color: _tileController.drawerIndex == uniqueId
                                  ? Color(accentMenuColor.value)
                                  : primaryMenuColor,
                            )),
                  Expanded(
                    child: Text(
                      _tileController.drawerWidth == 250 ? title! : "",
                      maxLines: 1,
                      style: TextStyle(
                          color: _tileController.drawerIndex == uniqueId
                              ? Color(accentMenuColor.value)
                              : primaryMenuColor,
                          fontFamily: 'OpenSans',
                          fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
