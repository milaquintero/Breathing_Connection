import 'package:breathing_connection/models/technique.dart';
import 'package:flutter/material.dart';

import '../styles.dart';
class TechniqueSection extends StatelessWidget {
  final String headerText;
  final String bgImage;
  final Technique technique;
  final Color textBgColor;
  final Color textColor;
  TechniqueSection({this.headerText, this.bgImage, this.technique,
    this.textBgColor, this.textColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      width: 320,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(bgImage),
          fit: BoxFit.fitHeight,
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: roundedBorder,
              color: textBgColor,
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    headerText,
                    style: TextStyle(
                      fontSize: 27,
                      color: textColor
                    ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: roundedBorder,
              color: textBgColor
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      technique.title,
                      style: TextStyle(
                          fontSize: 24,
                          color: textColor
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        icon: Icon(
                            Icons.help,
                            color: textColor,
                            size: 32,
                        ),
                        onPressed: (){}
                        ),
                    IconButton(
                        icon: Icon(
                            Icons.play_circle_fill,
                            color: textColor,
                            size: 32,
                        ),
                        onPressed: (){}
                        ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
