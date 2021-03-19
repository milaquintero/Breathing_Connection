import 'package:flutter/material.dart';

import '../styles.dart';
import 'fancy_text_form_field.dart';

class FancyFormPage extends StatefulWidget {
  final Form form;
  final Color headerColor;
  final Color headerIconColor;
  final IconData headerIcon;
  FancyFormPage({this.form, this.headerIcon, this.headerColor, this.headerIconColor});
  @override
  _FancyFormPageState createState() => _FancyFormPageState();
}

class _FancyFormPageState extends State<FancyFormPage> {
  @override
  Widget build(BuildContext context) {
    //screen height
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: appBarHeight,
        title: Text(
          'Email Subscription',
          style: appBarTextStyle,
        ),
        centerTitle: true,
        backgroundColor: brandPrimary,
      ),
      body: Container(
        color: Colors.blue[50],
        padding: EdgeInsets.symmetric(horizontal: 36),
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
                    color: Colors.blue[50],
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
                  padding: EdgeInsets.only(top: 16, bottom: 12),
                  child: CircleAvatar(
                    backgroundColor: widget.headerColor,
                    radius: 49.34,
                    child: Icon(
                      widget.headerIcon,
                      size: 49.34,
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
