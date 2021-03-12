import 'package:breathing_connection/pages/app_settings.dart';
import 'package:breathing_connection/pages/technique_list.dart';
import 'package:breathing_connection/widgets/nav_link.dart';
import 'package:flutter/material.dart';
import 'package:breathing_connection/pages/home.dart';
class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    //list of links for side nav
    //TODO: receive this list from backend user service
    List<NavLink> navLinks = [
      NavLink(route: '/home', title: 'Home', icon: Icons.home),
      NavLink(route: '/technique-list', title: 'Techniques', icon: Icons.article_rounded),
      NavLink(route: '/settings', title: 'App Settings', icon: Icons.settings),
      NavLink(route: '/pro', title: 'Pro License', icon: Icons.add_moderator),
    ];
    return Scaffold(
      body: Builder(
        builder: (context){
          String currentRoute = navLinks[_currentIndex].route;
          if(currentRoute == '/home'){
            return Home();
          }
          else if(currentRoute == '/technique-list'){
            return TechniqueList();
          }
          else if(currentRoute == '/settings'){
            return AppSettings();
          }
          else{
            return Center(
                child: Text('Error: $currentRoute is not a valid route.')
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        elevation: 0,
        type : BottomNavigationBarType.fixed,
        items: navLinks.map((link)=> BottomNavigationBarItem(
            icon: Icon(link.icon),
            label: link.title
        )
        ).toList(),
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
