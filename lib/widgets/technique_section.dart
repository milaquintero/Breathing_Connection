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
  final IconData sectionIcon;
  TechniqueSection({this.headerText, this.bgImage, this.techniques,
    this.textBgColor, this.textColor, this.startIcon, this.sectionIcon,
    this.headerColor, this.headerTextColor});
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        color: headerColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Section Header
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                //fancy clipped circle in header background
                Positioned(
                    left: -160,
                    top: -100,
                    child: Container(
                      height: 400,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(300),
                        color: Colors.blueGrey[400],
                      ),
                    )
                ),
                //section header text
                Container(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    headerText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      color: headerTextColor,
                    ),
                  ),
                )
              ]
            ),
            //Section Content (list of sections)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: techniques.length,
                    itemBuilder: (context, index){
                      return Container(
                        padding: EdgeInsets.only(top: 106, bottom: 0, left: 32, right: 32),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(bgImage),
                                fit: BoxFit.cover,
                            ),
                        ),
                        height: 260,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: roundedBorder,
                                  color: textBgColor,
                                  gradient: RadialGradient(
                                    colors: [Colors.blueGrey, Color.lerp(textBgColor, Colors.blueGrey, 0.5), textBgColor],
                                    center: Alignment(0.6, -0.3),
                                    focal: Alignment(0.3, -0.1),
                                    focalRadius: 3.5,
                                  ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                clipBehavior: Clip.none,
                                children: [
                                  //section header icon
                                  Positioned(
                                    top: -120,
                                    child: CircleAvatar(
                                      radius: 45,
                                      backgroundColor: textBgColor,
                                      child: Icon(
                                        sectionIcon,
                                        size: 42,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        techniques[index].title,
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: textColor
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
                                ]
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
      ),
    );
  }
}
