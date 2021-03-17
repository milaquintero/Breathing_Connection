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
    String amTechniqueHeadBgImg = 'assets/day.jpg';
    String pmTechniqueHeadBgImg = 'assets/night.jpg';
    String challengeTechniqueHeadBgImg = 'assets/challenge.jpg';
    String customTechniqueHeadBgImg = 'assets/custom.jpg';
    String emergencyTechniqueHeadBgImg = 'assets/emergency.jpg';

    User curUser = Provider.of<User>(context);

    //main content to display in ListView
    List<Widget> mainContent = [
      TechniqueSection(
        headerText: 'Early Session',
        bgImage: amTechniqueHeadBgImg,
        techniques: [curUser.amTechnique],
        textBgColor: Colors.lightBlue[900],
        textColor: Colors.white,
        startIcon: Icons.play_circle_fill,
        headerColor: Colors.lightBlue[900],
        headerTextColor: Colors.white,
        sectionIcon: Icons.wb_sunny,
      ),
      TechniqueSection(
        headerText: 'Late Session',
        bgImage: pmTechniqueHeadBgImg,
        techniques: [curUser.pmTechnique],
        textBgColor: Colors.pinkAccent[700],
        textColor: Colors.white,
        startIcon: Icons.play_circle_fill,
        headerColor: Colors.pinkAccent[700],
        headerTextColor: Colors.white,
        sectionIcon: Icons.night_shelter,
      ),
      TechniqueSection(
        headerText: 'Emergency',
        bgImage: emergencyTechniqueHeadBgImg,
        techniques: [curUser.emergencyTechnique],
        textBgColor: Colors.red[700],
        textColor: Colors.white,
        startIcon: Icons.add_circle,
        headerColor: Colors.red[700],
        headerTextColor: Colors.white,
        sectionIcon: Icons.healing,
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
          textBgColor: Colors.teal[800],
          textColor: Colors.white,
          startIcon: Icons.play_circle_fill,
          headerColor: Colors.teal[800],
          headerTextColor: Colors.white,
          sectionIcon: Icons.directions_run,
        )
      );
      //add formatted custom techniques
      mainContent.add(
        TechniqueSection(
          headerText: 'Custom Session',
          bgImage: customTechniqueHeadBgImg,
          techniques: curUser.customTechniques,
          textBgColor: Colors.deepOrangeAccent[400],
          textColor: Colors.white,
          startIcon: Icons.play_circle_fill,
          headerColor: Colors.deepOrangeAccent[400],
          headerTextColor: Colors.white,
          sectionIcon: Icons.dashboard_customize,
        )
      );
    }
    //screen height
    double screenHeight = MediaQuery.of(context).size.height;
    return IconPage(
      headerColor: Colors.white,
      headerContent: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(top: 42, bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/logo_with_name.jpg',
                  height: screenHeight / 4.3,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Text(
                    'Your breathing Journey',
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      mainContentHeight: screenHeight / 2.05,
      mainContentColor: brandPrimary,
      //remove padding automatically added by ListView
      mainContent: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: mainContent,
        ),
      )
    );
  }
}
