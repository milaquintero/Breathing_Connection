import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:breathing_connection/widgets/nav_link.dart';
import 'package:breathing_connection/widgets/technique_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
    NavLink(route: '/home', title: 'Home', icon: Icons.home),
    NavLink(route: '/technique-list', title: 'Techniques', icon: Icons.article_rounded),
    NavLink(route: '/settings', title: 'App Settings', icon: Icons.settings),
    NavLink(route: '/pro', title: 'Pro License', icon: Icons.add_moderator),
  ];
  User curUser = UserService.curUser;
  @override
  Widget build(BuildContext context) {
    //main content to display in ListView
    List<Widget> mainContent = [
      SizedBox(height: 16),
      TechniqueSection(
        headerText: 'Early Session',
        bgImage: amTechniqueHeadBgImg,
        technique: curUser.amTechnique,
        textBgColor: Colors.black,
        textColor: Colors.white
      ),
      TechniqueSection(
        headerText: 'Late Session',
        bgImage: pmTechniqueHeadBgImg,
        technique: curUser.pmTechnique,
        textBgColor: Colors.grey[50],
        textColor: Colors.grey[900]
      ),
      TechniqueSection(
        headerText: 'Challenge',
        bgImage: challengeTechniqueHeadBgImg,
        technique: curUser.challengeTechnique,
        textBgColor: Colors.black,
        textColor: Colors.white
      ),
    ];
    //check if user has paid version
    if(curUser.hasFullAccess){
      //format custom techniques into technique cards
      List<TechniqueSection> customTechniques = curUser.customTechniques.map(
              (customTechnique)=> TechniqueSection(
                  headerText: 'Custom',
                  bgImage: customTechniqueHeadBgImg,
                  technique: customTechnique,
                  textBgColor: Colors.white,
                  textColor: Colors.black
              )
      ).toList();
      //add formatted custom techniques
      mainContent.addAll(customTechniques);
    }

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 84, 0, 0),
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
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: wellSectionBg
                  ),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: mainContent,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type : BottomNavigationBarType.fixed,
        items: sideNavLinks.map((link)=> BottomNavigationBarItem(
          icon: Icon(link.icon),
          label: link.title
          )
        ).toList(),
        onTap: (index){
          //only switch route if changing from home (first link)
          if(index != 0){
            setState(() {
              Navigator.pushNamed(context, sideNavLinks[index].route);
            });
          }
        },
      ),
    );
  }
}
