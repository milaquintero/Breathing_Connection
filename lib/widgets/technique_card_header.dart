import 'package:flutter/material.dart';

import '../styles.dart';
class TechniqueCardHeader extends StatelessWidget {
  final String headerText;
  final Color bgColor;
  TechniqueCardHeader({this.headerText, this.bgColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: techniqueCardHeadContainerMargin,
      padding: techniqueCardHeadContainerPadding,
      decoration: BoxDecoration(
        borderRadius: roundedBorder,
        color: bgColor
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              headerText,
              style: techniqueCardHeadTextStyle,
          ),
        ],
      ),
    );
  }
}
