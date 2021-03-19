import 'package:breathing_connection/models/technique.dart';
import 'package:flutter/material.dart';

import '../styles.dart';
class TechniqueSection extends StatelessWidget {
  final String headerText;
  final List<Technique> techniques;
  final Color textBgColor;
  final Color textColor;
  final Color headerColor;
  final Color headerTextColor;
  final IconData startIcon;
  final IconData sectionIcon;
  TechniqueSection({this.headerText, this.techniques,
    this.textBgColor, this.textColor, this.startIcon, this.sectionIcon,
    this.headerColor, this.headerTextColor});
  @override
  Widget build(BuildContext context) {
    //screen height
    double screenHeight = MediaQuery.of(context).size.height;
    return ClipRect(
      child: Container(
        color: headerColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Section Header
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                //fancy clipped circle in header background
                Positioned(
                    left: -80,
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
                  padding: EdgeInsets.symmetric(vertical: screenHeight / 36),
                  child: Text(
                    headerText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenHeight / 24,
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
                        padding: EdgeInsets.symmetric(horizontal: screenHeight / 20),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(techniques[index].assetImage),
                                fit: BoxFit.cover,
                            ),
                        ),
                        height: screenHeight / 2.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: Offset(0, 3), // changes position of shadow
                                  )
                                ]
                              ),
                              child: CircleAvatar(
                                radius: screenHeight / 15,
                                backgroundColor: textBgColor,
                                child: Icon(
                                  sectionIcon,
                                  size: screenHeight / 15,
                                  color: textColor,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: textBgColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 3), // changes position of shadow
                                    )
                                  ],
                                  borderRadius: roundedBorder,
                                  gradient: RadialGradient(
                                    colors: [Colors.blueGrey, Color.lerp(textBgColor, Colors.blueGrey, 0.5), textBgColor],
                                    center: Alignment(0.6, -0.3),
                                    focal: Alignment(0.3, -0.1),
                                    focalRadius: 3.5,
                                  ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: screenHeight / 16, vertical: screenHeight / 50),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                clipBehavior: Clip.none,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        techniques[index].title,
                                        style: TextStyle(
                                            fontSize: screenHeight / 26,
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
                                                size: screenHeight / 18,
                                              ),
                                              onPressed: (){}
                                          ),
                                          IconButton(
                                              icon: Icon(
                                                startIcon,
                                                color: textColor,
                                                size: screenHeight / 18,
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
