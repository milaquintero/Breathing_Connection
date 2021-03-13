import 'package:breathing_connection/models/user.dart';
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
        fontSize: 24
    );
    String amTechniqueHeadBgImg = 'assets/day.jpg';
    String pmTechniqueHeadBgImg = 'assets/night.jpg';
    String challengeTechniqueHeadBgImg = 'assets/day.jpg';
    String customTechniqueHeadBgImg = 'assets/night.jpg';
    String emergencyTechniqueHeadBgImg = 'assets/night.jpg';

    User curUser = Provider.of<User>(context);

    //main content to display in ListView
    List<Widget> mainContent = [
      SizedBox(height: 16),
      TechniqueSection(
        headerText: 'Early Session',
        bgImage: amTechniqueHeadBgImg,
        technique: curUser.amTechnique,
        textBgColor: Colors.black,
        textColor: Colors.white,
        startIcon: Icons.play_circle_fill,
      ),
      TechniqueSection(
        headerText: 'Late Session',
        bgImage: pmTechniqueHeadBgImg,
        technique: curUser.pmTechnique,
        textBgColor: Colors.grey[50],
        textColor: Colors.grey[900],
        startIcon: Icons.play_circle_fill,
      ),
      TechniqueSection(
        headerText: 'Emergency',
        bgImage: emergencyTechniqueHeadBgImg,
        technique: curUser.emergencyTechnique,
        textBgColor: Colors.red[400],
        textColor: Colors.grey[50],
        startIcon: Icons.add_circle,
      )
    ];
    //check if user has paid version
    if(curUser.hasFullAccess){
      //add challenge section
      mainContent.add(
        TechniqueSection(
            headerText: 'Challenge',
            bgImage: challengeTechniqueHeadBgImg,
            technique: curUser.challengeTechnique,
            textBgColor: Colors.black,
            textColor: Colors.white,
            startIcon: Icons.play_circle_fill,
        )
      );
      //format custom techniques into technique cards
      List<TechniqueSection> customTechniques = curUser.customTechniques.map(
              (customTechnique)=> TechniqueSection(
                  headerText: 'Custom',
                  bgImage: customTechniqueHeadBgImg,
                  technique: customTechnique,
                  textBgColor: Colors.white,
                  textColor: Colors.black,
                  startIcon: Icons.play_circle_fill,
              )
      ).toList();
      //add formatted custom techniques
      mainContent.addAll(customTechniques);
    }

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
            child: Center(
              child: Image(
                image: AssetImage('assets/logo_with_name.jpg'),
                width: 200,
              ),
            ),
          ),
          Padding(
            padding: homeMainTextPadding,
            child: Text(
                'Your breathing Journey',
                style: homeMainTextStyle
            ),
          ),
          Flexible(
            child: ListView(
              padding: EdgeInsets.only(top: 32),
              scrollDirection: Axis.horizontal,
              children: mainContent,
            ),
          )
        ],
      ),
    );
  }
}
