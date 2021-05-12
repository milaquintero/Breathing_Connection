import 'package:breathing_connection/models/technique.dart';
import 'package:flutter/material.dart';

class TechniqueSection extends StatefulWidget {
  final String headerText;
  final List<Technique> techniques;
  final Color textBgColor;
  final Color textColor;
  final Color headerColor;
  final Color headerTextColor;
  final IconData startIcon;
  final Function(Technique) viewTechniqueDetails;
  final Function(Technique) beginTechniqueInEnvironment;
  final Color decorationColor;
  final String assetURL;
  TechniqueSection({this.headerText, this.techniques,
    this.textBgColor, this.textColor, this.startIcon,
    this.headerColor, this.headerTextColor, this.viewTechniqueDetails,
    this.decorationColor, this.assetURL, this.beginTechniqueInEnvironment});

  @override
  _TechniqueSectionState createState() => _TechniqueSectionState();
}

class _TechniqueSectionState extends State<TechniqueSection> {
  //screen height
  double screenHeight;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //screen height
    screenHeight = MediaQuery.of(context).size.height;
  }
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.blueGrey[400], Color.lerp(widget.headerColor, Colors.blueGrey[400], 0.01), widget.headerColor],
            center: Alignment(-10.5, 0.8),
            focal: Alignment(0.3, -0.1),
            focalRadius: 5.4,
          )
        ),
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
                      height: 450,
                      width: 450,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(300),
                        gradient: RadialGradient(
                          colors: [Colors.blueGrey[400], Color.lerp(widget.decorationColor, Colors.blueGrey[400], 0.01), widget.decorationColor],
                          center: Alignment(0.6, 0.3),
                          focal: Alignment(0.3, -0.1),
                          focalRadius: 0.5,
                        ),
                      ),
                    )
                ),
                //section header text
                Container(
                  padding: EdgeInsets.symmetric(vertical: 28),
                  child: Text(
                    widget.headerText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      color: widget.headerTextColor,
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
                    itemCount: widget.techniques.length,
                    itemBuilder: (context, index){
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: screenHeight / 18.5),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "${widget.assetURL}/${widget.techniques[index].assetImage}"
                                ),
                                fit: BoxFit.cover,
                            ),
                        ),
                        height: screenHeight / 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: widget.textBgColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 3), // changes position of shadow
                                    )
                                  ],
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  gradient: RadialGradient(
                                    colors: [Colors.blueGrey, Color.lerp(widget.textBgColor, Colors.blueGrey, 0.5), widget.textBgColor],
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
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 4),
                                        child: Text(
                                          widget.techniques[index].title ?? "",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: screenHeight / 28,
                                              color: widget.textColor
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton(
                                              icon: Icon(
                                                Icons.help,
                                                color: widget.textColor,
                                                size: screenHeight / 18,
                                              ),
                                              onPressed: (){
                                                widget.viewTechniqueDetails(widget.techniques[index]);
                                              }
                                          ),
                                          IconButton(
                                              icon: Icon(
                                                widget.startIcon,
                                                color: widget.textColor,
                                                size: screenHeight / 18,
                                              ),
                                              onPressed: (){
                                                widget.beginTechniqueInEnvironment(widget.techniques[index]);
                                              }
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
