import 'package:breathing_connection/models/technique.dart';
import 'package:flutter/material.dart';

import '../styles.dart';
class TechniqueSection extends StatelessWidget {
  final String headerText;
  final String bgImage;
  final List<Technique> techniques;
  final Color textBgColor;
  final Color textColor;
  final Color headerColor;
  final Color headerTextColor;
  final IconData startIcon;
  TechniqueSection({this.headerText, this.bgImage, this.techniques,
    this.textBgColor, this.textColor, this.startIcon,
    this.headerColor, this.headerTextColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: headerColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text(
              headerText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                color: headerTextColor,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: techniques.length,
                  itemBuilder: (context, index){
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 28, horizontal: 32),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(bgImage),
                              fit: BoxFit.fitWidth
                          )
                      ),
                      height: 240,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: roundedBorder,
                                color: textBgColor
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    techniques[index].title,
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: textColor
                                    ),
                                  ),
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
                                          startIcon,
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
              )
            ],
          )
        ]
      ),
    );
  }
}
