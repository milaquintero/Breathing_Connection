import 'package:flutter/material.dart';

class FancyScrollablePage extends StatefulWidget {
  final String pageTitle;
  final Widget child;
  final Color headerColor;
  final Color headerIconColor;
  final IconData headerIcon;
  final Color appBarColor;
  final Color bgColor;
  final bool withIconHeader;
  final Color decorationPrimaryColor;
  final Color decorationSecondaryColor;
  final double appBarHeight;
  FancyScrollablePage({this.child, this.headerIcon, this.headerColor, this.headerIconColor,
    this.pageTitle, this.appBarColor, this.bgColor, this.withIconHeader = false,
    this.decorationSecondaryColor, this.decorationPrimaryColor, this.appBarHeight});
  @override
  _FancyScrollablePageState createState() => _FancyScrollablePageState();
}

class _FancyScrollablePageState extends State<FancyScrollablePage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    //screen height
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: widget.appBarHeight,
        title: Text(
          widget.pageTitle,
          style: TextStyle(
              fontSize: 24
          ),
        ),
        centerTitle: true,
        backgroundColor: widget.appBarColor,
      ),
      body: Container(
        color: widget.bgColor ?? Colors.blue[50],
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned(
                bottom: -200,
                left: -240,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(300),
                  child: Container(
                    width: 400,
                    height: 400,
                    color: widget.decorationPrimaryColor,
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
                    color: widget.bgColor ?? Colors.blue[50],
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
                    color: widget.decorationPrimaryColor,
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
                    color: widget.decorationSecondaryColor.withOpacity(0.4),
                  ),
                )
            ),
            ListView(
              children: [
                //icon header
                widget.withIconHeader ? Padding(
                  padding: EdgeInsets.only(top: 36, bottom: 16),
                  child: CircleAvatar(
                    backgroundColor: widget.headerColor,
                    radius: screenHeight / 10.25,
                    child: Icon(
                      widget.headerIcon,
                      size: screenHeight / 10.25,
                      color: widget.headerIconColor,
                    ),
                  ),
                ) : Container(),
                //add form after icon header
                widget.child
              ],
            ),
          ],
        ),
      ),
    );
  }
}
