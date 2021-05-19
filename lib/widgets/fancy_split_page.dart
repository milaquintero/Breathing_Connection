import 'package:flutter/material.dart';
class FancySplitPage extends StatelessWidget {
  final Widget mainContent;
  final Widget headerContent;
  final double headerPositionTop;
  final Color headerColor;
  final Color mainContentColor;
  final bool withFloatingActionButton;
  final Widget floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  FancySplitPage({this.mainContent, this.headerContent,
  this.headerPositionTop,
  this.headerColor, this.mainContentColor, this.withFloatingActionButton = false,
  this.floatingActionButton, this.floatingActionButtonLocation});
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
      floatingActionButton: withFloatingActionButton ? floatingActionButton : Container(),
      floatingActionButtonLocation: withFloatingActionButton ? floatingActionButtonLocation : FloatingActionButtonLocation.endFloat,
    );
  }
}
