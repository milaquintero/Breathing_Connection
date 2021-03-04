import 'package:flutter/material.dart';
//Brand styles (across all pages)
Color brandPrimary = Colors.lightBlue[900];
Color wellSectionBg = Colors.blueGrey[200];
BorderRadius roundedBorder = BorderRadius.all(Radius.circular(5));
double appBarHeight = 72;
TextStyle appBarTextStyle = TextStyle(
    fontSize: 24
);
//Loading page style
Color spinnerColor = Colors.white;
double spinnerSize = 80.0;
Color loadingBgColor = brandPrimary;

//Home page style
EdgeInsets homeLogoPadding = EdgeInsets.fromLTRB(0, 24, 0, 0);
EdgeInsets homeMainTextPadding = EdgeInsets.fromLTRB(0, 32, 0, 0);
TextStyle homeMainTextStyle = TextStyle(
    fontSize: 24
);
Color amTechniqueHeadBgColor = Colors.green[900];
Color pmTechniqueHeadBgColor = Colors.indigo[900];
Color challengeTechniqueHeadBgColor = Colors.orange[900];
Color customTechniqueHeadBgColor = Colors.yellow[900];

//Technique card style
EdgeInsets techniqueCardContainerPadding = EdgeInsets.fromLTRB(8,8,8,8);
EdgeInsets techniqueCardContentPadding = EdgeInsets.symmetric(vertical: 8, horizontal: 12);
//Technique card header style
EdgeInsets techniqueCardHeadContainerMargin = EdgeInsets.fromLTRB(16,4,16,4);
EdgeInsets techniqueCardHeadContainerPadding = EdgeInsets.symmetric(vertical: 10);
TextStyle techniqueCardHeadTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 20,
);