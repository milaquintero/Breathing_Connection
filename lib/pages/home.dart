import 'package:breathing_connection/widgets/nav_link.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(navLinks: this.sideNavLinks, headerImg: this.sideNavHeaderImg),
      appBar: AppBar(
        toolbarHeight: appBarHeight,
        backgroundColor: homeAppBarBg,
        centerTitle: true,
        elevation: 0,
        title: Text(
            'Breathing Connection',
            style: homeAppBarTextStyle,
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
            )
          ],
        ),
      ),
    );
  }
}
