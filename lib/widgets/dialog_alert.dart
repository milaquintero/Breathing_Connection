import 'package:flutter/material.dart';

class DialogAlert extends StatelessWidget {
  final Function cbFunction;
  final String buttonText;
  final String titleText;
  final String subtitleText;
  final IconData headerIcon;
  final Color buttonColor;
  final Color headerBgColor;
  final Color titleTextColor;
  final EdgeInsets titlePadding;
  final EdgeInsets subtitlePadding;
  final Color bgColor;
  final Color subtitleTextColor;
  DialogAlert({this.buttonText, this.cbFunction,
    this.titleText, this.subtitleText, this.headerIcon,
    this.buttonColor, this.headerBgColor, this.titleTextColor,
    this.titlePadding, this.subtitlePadding, this.bgColor, this.subtitleTextColor});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0)
      ),
      backgroundColor: bgColor,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: EdgeInsets.only(top: 28, bottom: 28, left: 12, right: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: titlePadding,
                  child: Text(
                    titleText,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: titleTextColor ?? Colors.lightBlue[900]
                    ),
                  ),
                ),
                Padding(
                  padding: subtitlePadding,
                  child: Text(
                    subtitleText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18.5,
                        color: subtitleTextColor ?? Colors.grey[700]
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: (){
                        //close dialog
                        Navigator.of(context).pop();
                        //run callback function
                        cbFunction();
                      },
                      child: Text(
                        buttonText,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24
                        ),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32)
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: -60,
            child: CircleAvatar(
              backgroundColor: headerBgColor,
              radius: 40,
              child: Icon(
                headerIcon,
                color: Colors.white,
                size: 50,
              ),
            ),
          )
        ],
      ),
    );
  }
}
