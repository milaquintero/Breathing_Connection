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
  final double dialogHeight;
  final EdgeInsets titlePadding;
  final EdgeInsets subtitlePadding;
  DialogAlert({this.buttonText, this.cbFunction,
    this.titleText, this.subtitleText, this.headerIcon,
    this.buttonColor, this.headerBgColor, this.titleTextColor,
    this.dialogHeight, this.titlePadding, this.subtitlePadding});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0)
      ),
      backgroundColor: Colors.grey[50],
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: dialogHeight,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Column(
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
                        color: Colors.grey[700]
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
