import 'package:flutter/material.dart';
class FancySplitPage extends StatelessWidget {
  final Widget mainContent;
  final Widget headerContent;
  final double mainContentHeight;
  final double headerPositionTop;
  final Color headerColor;
  final Color mainContentColor;
  FancySplitPage({this.mainContent, this.headerContent,
  this.headerPositionTop, this.mainContentHeight,
  this.headerColor, this.mainContentColor});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainContentColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            headerContent,
            Expanded(
              child: mainContent,
            )
          ],
        ),
      ),
    );
  }
}
