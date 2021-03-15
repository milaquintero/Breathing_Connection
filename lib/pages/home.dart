import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/widgets/icon_page.dart';
import 'package:breathing_connection/widgets/technique_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../styles.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //image header for side nav
  String sideNavHeaderImg = 'assets/logo_with_name.jpg';
  @override
  Widget build(BuildContext context) {
    //styling
    EdgeInsets homeMainTextPadding = EdgeInsets.fromLTRB(0, 28, 0, 0);
    TextStyle homeMainTextStyle = TextStyle(
      fontSize: 24,
      color: Colors.black
    );
    String amTechniqueHeadBgImg = 'assets/day.jpg';
    String pmTechniqueHeadBgImg = 'assets/night.jpg';
    String challengeTechniqueHeadBgImg = 'assets/day.jpg';
    String customTechniqueHeadBgImg = 'assets/day.jpg';
    String emergencyTechniqueHeadBgImg = 'assets/night.jpg';

    User curUser = Provider.of<User>(context);

    //main content to display in ListView
    List<Widget> mainContent = [
      TechniqueSection(
        headerText: 'Early Session',
        bgImage: amTechniqueHeadBgImg,
        techniques: [curUser.amTechnique],
        textBgColor: Colors.grey[900],
        textColor: Colors.grey[50],
        startIcon: Icons.play_circle_fill,
        headerColor: Colors.lightBlue[900],
        headerTextColor: Colors.grey[50],
      ),
      TechniqueSection(
        headerText: 'Late Session',
        bgImage: pmTechniqueHeadBgImg,
        techniques: [curUser.pmTechnique],
        textBgColor: Colors.white,
        textColor: Colors.black,
        startIcon: Icons.play_circle_fill,
        headerColor: Colors.indigo[600],
        headerTextColor: Colors.grey[50],
      ),
      TechniqueSection(
        headerText: 'Emergency',
        bgImage: emergencyTechniqueHeadBgImg,
        techniques: [curUser.emergencyTechnique],
        textBgColor: Colors.grey[600],
        textColor: Colors.white,
        startIcon: Icons.add_circle,
        headerColor: Colors.red,
        headerTextColor: Colors.white,
      )
    ];
    //check if user has paid version
    if(curUser.hasFullAccess){
      //add challenge section
      mainContent.add(
        TechniqueSection(
          headerText: 'Challenge',
          bgImage: challengeTechniqueHeadBgImg,
          techniques: [curUser.challengeTechnique],
          textBgColor: Colors.grey[600],
          textColor: Colors.white,
          startIcon: Icons.play_circle_fill,
          headerColor: Colors.deepOrange,
          headerTextColor: Colors.grey[50],
        )
      );
      //add formatted custom techniques
      mainContent.add(
        TechniqueSection(
          headerText: 'Custom Session',
          bgImage: customTechniqueHeadBgImg,
          techniques: curUser.customTechniques,
          textBgColor: Colors.grey[600],
          textColor: Colors.white,
          startIcon: Icons.play_circle_fill,
          headerColor: Colors.grey[900],
          headerTextColor: Colors.grey[50],
        )
      );
    }
    return IconPage(
      headerColor: Colors.white,
      headerPositionTop: 40,
      headerContent: Container(
        height: 265,
        width: 300,
        padding: EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/logo_with_name.jpg',
              height: 190,
            ),
            Padding(
              padding: homeMainTextPadding,
              child: Text(
                'Your breathing Journey',
                style: homeMainTextStyle,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
      mainContentHeight: 430,
      mainContentColor: brandPrimary,
      mainContent: ListView(
        children: mainContent,
      ),
    );
  }
}
