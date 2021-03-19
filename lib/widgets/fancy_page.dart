import 'package:flutter/material.dart';
class FancyPage extends StatelessWidget {
  final Widget mainContent;
  final Widget headerContent;
  final double mainContentHeight;
  final double headerPositionTop;
  final Color headerColor;
  final Color mainContentColor;
  FancyPage({this.mainContent, this.headerContent,
  this.headerPositionTop, this.mainContentHeight,
  this.headerColor, this.mainContentColor});
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //left over space at the top
            Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: headerColor
                  ),
                )
            ),
            //MAIN CONTENT
            Container(
              height: mainContentHeight,
              color: mainContentColor,
              child: mainContent,
            ),
          ],
        ),
        //fixed position icon
        Positioned(
          top: headerPositionTop,
          child: headerContent,
        )
      ],
    );
  }
}
