import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobi_resize_flutter/utils/colors.dart';
import 'package:mobi_resize_flutter/utils/resources.dart';

class MobiDrawerSectionTitle extends StatelessWidget {
  final _sectionController = Get.find<ResourcesController>();
  final String? title;
  MobiDrawerSectionTitle({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResourcesController>(
        init: _sectionController,
        builder: (data) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.linear,
            height: 20,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: 24,
                top:
                    data.drawerWidth == 70 ? (data.getIsMobile() ? 10 : 0) : 10,
                bottom: data.drawerWidth == 70
                    ? (data.getIsMobile() ? 10 : 0)
                    : 10),
            child: Text(
              data.drawerWidth == 70
                  ? (data.getIsMobile() ? title! : "")
                  : title!,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 14,
                  color: primaryMenuColor),
            ),
          );
        });
  }
}
