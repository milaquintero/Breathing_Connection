import 'package:breathing_connection/main.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:breathing_connection/widgets/nav_link.dart';
import 'package:breathing_connection/widgets/technique_card.dart';
import 'package:breathing_connection/widgets/technique_card_header.dart';
import 'package:flutter/material.dart';
import 'package:breathing_connection/widgets/nav_drawer.dart';

import '../styles.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //image header for side nav
  String sideNavHeaderImg = 'assets/logo_with_name.jpg';
  //list of links for side nav
  //TODO: receive this list from backend user service
  List<NavLink> sideNavLinks = [
    NavLink(route: '/pro', title: 'Pro License', icon: Icons.add_moderator),
    NavLink(route: '/technique-list', title: 'Techniques', icon: Icons.article_rounded),
    NavLink(route: '/settings', title: 'App Settings', icon: Icons.settings),
  ];
  User curUser = UserService.curUser;
  @override
  Widget build(BuildContext context) {
    //main content to display in ListView
    List<Widget> mainContent = [
      SizedBox(height: 16),
      TechniqueCardHeader(headerText: 'AM', bgColor: amTechniqueHeadBgColor,),
      TechniqueCard(
        technique: curUser.amTechnique,
      ),
      TechniqueCardHeader(headerText: 'PM', bgColor: pmTechniqueHeadBgColor,),
      TechniqueCard(
        technique: this.curUser.pmTechnique,
      ),
      TechniqueCardHeader(headerText: 'Challenge', bgColor: challengeTechniqueHeadBgColor,),
      TechniqueCard(
        technique: curUser.challengeTechnique,
      )
    ];
    //check if user has paid version
    if(curUser.hasFullAccess){
      //add header if user has paid version
      mainContent.add(
          TechniqueCardHeader(headerText: 'Custom', bgColor: customTechniqueHeadBgColor,)
      );
      //format custom techniques into technique cards
      List<TechniqueCard> customTechniques = curUser.customTechniques.map(
              (customTechnique)=> TechniqueCard(technique: customTechnique)
      ).toList();
      //add formatted custom techniques
      mainContent.addAll(customTechniques);
    }

    return Scaffold(
      drawer: NavDrawer(navLinks: this.sideNavLinks, headerImg: this.sideNavHeaderImg),
      appBar: AppBar(
        toolbarHeight: appBarHeight,
        backgroundColor: brandPrimary,
        centerTitle: true,
        elevation: 0,
        title: Text(
            'Breathing Connection',
            style: appBarTextStyle,
        )
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: homeLogoPadding,
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(8, 22, 8, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: wellSectionBg,
                    borderRadius: roundedBorder
                  ),
                  child: ListView(
                    children: mainContent,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
