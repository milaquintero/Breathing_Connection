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
  final bool withAppBar;
  final List<Widget> actions;
  final Widget notification;
  FancyScrollablePage({this.child, this.headerIcon, this.headerColor, this.headerIconColor,
    this.pageTitle, this.appBarColor, this.bgColor, this.withIconHeader = false,
    this.decorationSecondaryColor, this.decorationPrimaryColor, this.appBarHeight,
    this.withAppBar = true, this.actions, this.notification});
  @override
  _FancyScrollablePageState createState() => _FancyScrollablePageState();
}

class _FancyScrollablePageState extends State<FancyScrollablePage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    //screen height
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: widget.withAppBar ? AppBar(
          toolbarHeight: widget.appBarHeight,
          title: Text(
            widget.pageTitle,
            style: TextStyle(
                fontSize: 30,
                letterSpacing: -0.25
            ),
          ),
          centerTitle: true,
          backgroundColor: widget.appBarColor,
          actions: widget.actions ?? [],
        ) : null,
        body: Container(
          color: widget.bgColor ?? Colors.blue[50],
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
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  children: [
                    widget.notification != null ? widget.notification : Container(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          //icon header
                          if (widget.withIconHeader) Padding(
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
                          ) else Container(),
                          //add form after icon header
                          widget.child],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
