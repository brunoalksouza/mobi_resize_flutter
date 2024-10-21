import 'package:flutter/material.dart';
import 'package:mobi_resize_flutter/utils/colors.dart';
import 'package:mobi_resize_flutter/widgets/closed_drawer_mobi/mobi_drawer_tile.dart';

class MobiDrawerSection extends StatelessWidget {
  final List<MobiDrawerTile>? children;
  final Widget? sectionTitle;
  final double? width;
  final bool special;

  const MobiDrawerSection(
      {Key? key,
      this.children,
      this.sectionTitle,
      this.width,
      this.special = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: this.special ? secondaryColor : backgroundMenuColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      child: Column(
        children: [
          this.sectionTitle != null ? sectionTitle! : Container(),
          Column(
            children: children!,
          ),
        ],
      ),
    );
  }
}
