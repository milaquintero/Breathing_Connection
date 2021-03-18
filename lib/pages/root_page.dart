import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/nav_link.dart';
import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/pages/app_settings_page.dart';
import 'package:breathing_connection/pages/page_not_found.dart';
import 'package:breathing_connection/pages/pro_license_page.dart';
import 'package:breathing_connection/pages/technique_list_page.dart';
import 'package:flutter/material.dart';
import 'package:breathing_connection/pages/home_page.dart';
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
    List<NavLink> navLinks = List<NavLink>.from(mainData.pages);
    return Scaffold(
      body: Builder(
        builder: (context){
          int currentIndex = curPage.pageIndex;
          String currentRoute = navLinks[currentIndex].pageRoute;
          if(currentRoute == '/home'){
            return HomePage(rootContext: context,);
          }
          else if(currentRoute == '/technique-list'){
            return TechniqueListPage(rootContext: context);
          }
          else if(currentRoute == '/settings'){
            return AppSettingsPage();
          }
          else if(currentRoute == '/pro'){
            return ProLicensePage(rootContext: context,);
          }
          else{
            return PageNotFound(rootContext: context, hasBottomNav: true,);
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
