import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobi_resize_flutter/utils/colors.dart';
import 'package:mobi_resize_flutter/utils/drawer.dart';
import 'package:mobi_resize_flutter/utils/images.dart';
import 'package:mobi_resize_flutter/utils/resources.dart';
import 'package:mobi_resize_flutter/widgets/closed_drawer_mobi/mobi_drawer_tile.dart';

class MobiDrawer extends StatelessWidget {
  final _drawerController = Get.find<ResourcesController>();
  final double? width;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  MobiDrawer({Key? key, this.width, this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResourcesController>(
        init: _drawerController,
        builder: (data) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: data.drawerWidth,
            color: backgroundMenuColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                data.getIsMobile()
                    ? Container(
                        padding: EdgeInsets.all(5.0),
                        width: data.drawerWidth,
                        height: kToolbarHeight,
                        decoration: BoxDecoration(
                          color: backgroundMenuColor,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 2),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(menu),
                        ),
                      )
                    : Container(),
                Expanded(
                  child: ListView(
                    children: mobiDrawer,
                  ),
                ),
                MobiDrawerTile(
                  selectable: false,
                  uniqueId: 0,
                  icon: data.drawerWidth == 70
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.arrow_back_ios_rounded,
                  title: "Fechar",
                  onTap: () {
                    if (data.getIsMobile()) {
                      if (data.drawerWidth != 70) {
                        Navigator.of(context).pop();
                      }
                    } else {
                      if (data.drawerWidth == 70) {
                        data.setDrawerWidth(250);
                      } else {
                        data.setDrawerWidth(70);
                      }
                    }
                  },
                )
              ],
            ),
          );
        });
  }
}
