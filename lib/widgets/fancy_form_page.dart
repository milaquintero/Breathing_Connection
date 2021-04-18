import 'package:breathing_connection/widgets/fancy_scrollable_page.dart';
import 'package:flutter/material.dart';

class FancyFormPage extends StatefulWidget {
  final String pageTitle;
  final Form form;
  final Color headerColor;
  final Color headerIconColor;
  final IconData headerIcon;
  final Color appBarColor;
  final Color bgColor;
  final bool withIconHeader;
  final Color decorationPrimaryColor;
  final Color decorationSecondaryColor;
  final double appBarHeight;
  FancyFormPage({this.form, this.headerIcon, this.headerColor, this.headerIconColor,
  this.pageTitle, this.appBarColor, this.bgColor, this.withIconHeader = false,
  this.decorationSecondaryColor, this.decorationPrimaryColor, this.appBarHeight});
  @override
  _FancyFormPageState createState() => _FancyFormPageState();
}

class _FancyFormPageState extends State<FancyFormPage> {
  @override
  Widget build(BuildContext context) {
    //screen height
    return FancyScrollablePage(
      child: widget.form,
      headerIconColor: widget.headerIconColor,
      headerColor: widget.headerColor,
      headerIcon: widget.headerIcon,
      pageTitle: widget.pageTitle,
      appBarColor: widget.appBarColor,
      bgColor: widget.bgColor,
      withIconHeader: widget.withIconHeader,
      decorationPrimaryColor: widget.decorationPrimaryColor,
      decorationSecondaryColor: widget.decorationSecondaryColor,
      appBarHeight: widget.appBarHeight,
    );
  }
}
