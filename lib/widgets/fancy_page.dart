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
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [

                  Positioned(
                      bottom: -200,
                      left: -240,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(300),
                        child: Container(
                          width: 400,
                          height: 400,
                          color: Colors.grey,
                        ),
                      )
                  ),
                  Positioned(
                      bottom: -190,
                      left: -250,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(300),
                        child: Container(
                          width: 350,
                          height: 350,
                          color: mainContentColor,
                        ),
                      )
                  ),
                  Positioned(
                      bottom: -200,
                      right: -240,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(300),
                        child: Container(
                          width: 400,
                          height: 400,
                          color: Colors.grey,
                        ),
                      )
                  ),
                  Positioned(
                      bottom: 0,
                      right: -280,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(300),
                        child: Container(
                          width: 400,
                          height: 400,
                          color: Colors.blue[200].withOpacity(0.4),
                        ),
                      )
                  ),
                  mainContent,
                ],
              ),
            ),
          ],
        ),
        //fixed position icon
        Positioned(
          top: headerPositionTop,
          child: headerContent,
        ),
      ],
    );
  }
}
