import 'package:flutter/material.dart';

import '../styles.dart';

class FancyFormPage extends StatefulWidget {
  final String pageTitle;
  final Form form;
  final Color headerColor;
  final Color headerIconColor;
  final IconData headerIcon;
  final Color appBarColor;
  final Color bgColor;
  FancyFormPage({this.form, this.headerIcon, this.headerColor, this.headerIconColor,
  this.pageTitle, this.appBarColor, this.bgColor});
  @override
  _FancyFormPageState createState() => _FancyFormPageState();
}

class _FancyFormPageState extends State<FancyFormPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    //screen height
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: appBarHeight,
        title: Text(
          widget.pageTitle,
          style: appBarTextStyle,
        ),
        centerTitle: true,
        backgroundColor: widget.appBarColor ?? brandPrimary,
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
            ListView(
              children: [
                //icon header
                Padding(
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
                ),
                //add form after icon header
                widget.form
              ],
            ),
          ],
        ),
      ),
    );
  }
}
