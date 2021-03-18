import 'package:flutter/material.dart';
import '../styles.dart';

class DialogPrompt extends StatelessWidget {
  final Function cbFunction;
  final String approveButtonText;
  final String denyButtonText;
  final String titleText;
  final String subtitleText;
  final IconData headerIcon;
  final Color approveButtonColor;
  final Color denyButtonColor;
  final Color headerBgColor;
  DialogPrompt({this.cbFunction, this.denyButtonText, this.approveButtonText,
    this.titleText, this.subtitleText, this.headerIcon,
    this.approveButtonColor, this.denyButtonColor, this.headerBgColor});
  @override
  Widget build(BuildContext context) {
    //screen height
    double screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0)
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: screenHeight / 2.1,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    titleText,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.lightBlue[900]
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 20, left: 24, right: 24),
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
                        //run call back function
                        cbFunction();
                      },
                      child: Text(
                        approveButtonText,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                        ),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: approveButtonColor,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24)
                      ),
                    ),
                    TextButton(
                      onPressed: (){
                        //close dialog
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        denyButtonText,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                        ),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: denyButtonColor,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24)
                      ),
                    )
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
