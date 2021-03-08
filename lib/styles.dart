import 'package:flutter/material.dart';
//Brand styles (across all pages)
Color brandPrimary = Colors.lightBlue[900];
Color wellSectionBg = Colors.white;
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
EdgeInsets homeMainTextPadding = EdgeInsets.fromLTRB(0, 28, 0, 0);
TextStyle homeMainTextStyle = TextStyle(
    fontSize: 24
);
String amTechniqueHeadBgImg = 'assets/day.jpg';
String pmTechniqueHeadBgImg = 'assets/night.jpg';
String challengeTechniqueHeadBgImg = 'assets/day.jpg';
String customTechniqueHeadBgImg = 'assets/night.jpg';

//Technique card header style
TextStyle techniqueCardHeadTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 20,
);