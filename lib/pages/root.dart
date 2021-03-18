import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/nav_link.dart';
import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/pages/app_settings.dart';
import 'package:breathing_connection/pages/page_not_found.dart';
import 'package:breathing_connection/pages/pro_license.dart';
import 'package:breathing_connection/pages/technique_list.dart';
import 'package:flutter/material.dart';
import 'package:breathing_connection/pages/home.dart';
import 'package:provider/provider.dart';
class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    MainData mainData = Provider.of<MainData>(context);
    CurrentPageHandler curPage = Provider.of<CurrentPageHandler>(context);
    //list of links for side nav
    List<NavLink> navLinks = mainData.pages;
    return Scaffold(
      body: Builder(
        builder: (context){
          int currentIndex = curPage.pageIndex;
          String currentRoute = navLinks[currentIndex].pageRoute;
          if(currentRoute == '/home'){
            return Home(rootContext: context,);
          }
          else if(currentRoute == '/technique-list'){
            return TechniqueList(rootContext: context);
          }
          else if(currentRoute == '/settings'){
            return AppSettings();
          }
          else if(currentRoute == '/pro'){
            return ProLicense(rootContext: context,);
          }
          else{
            return PageNotFound(rootContext: context,);
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: curPage.pageIndex,
        elevation: 0,
        type : BottomNavigationBarType.fixed,
        items: navLinks.map((link)=> BottomNavigationBarItem(
            icon: Icon(link.pageIcon),
            label: link.pageTitle
        )
        ).toList(),
        onTap: (index){
          Provider.of<CurrentPageHandler>(context, listen: false).setPageIndex(index);
        },
      ),
    );
  }
}
