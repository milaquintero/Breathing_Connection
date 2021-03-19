import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/styles.dart';
import 'package:breathing_connection/widgets/fancy_page.dart';
import 'package:flutter/material.dart';
import 'package:breathing_connection/models/nav_link.dart';
import 'package:provider/provider.dart';
class ProLicensePage extends StatefulWidget {
  final BuildContext rootContext;
  ProLicensePage({this.rootContext});

  @override
  _ProLicensePageState createState() => _ProLicensePageState();
}

class _ProLicensePageState extends State<ProLicensePage> {
  @override
  Widget build(BuildContext context) {
    //available nav links from provider
    List<NavLink> navLinks = Provider.of<MainData>(widget.rootContext).pages;
    //find home page in main data page links
    NavLink homePage = navLinks.firstWhere((page) => page.pageRoute == '/home');
    //screen height
    double screenHeight = MediaQuery.of(context).size.height;
    return FancyPage(
      headerColor: Colors.grey,
      headerPositionTop: screenHeight / 15,
      headerContent: CircleAvatar(
        backgroundColor: Colors.teal[600],
        radius: screenHeight / 10,
        child: Icon(
          Icons.add_moderator,
          size: screenHeight / 10,
          color: Colors.grey[50],
        ),
      ),
      mainContentHeight: screenHeight / 1.36,
      mainContentColor: brandPrimary,
      mainContent:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: screenHeight / 2.3,
            height: screenHeight / 2,
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.only(top: 15, bottom: 20, left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey[50],
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'Breathe In',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight / 14,
                        color: Colors.blueGrey[700]
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 28),
                  child: Text(
                    'Gain access to all of Breathing Connection\'s features to immerse yourself in our environment!',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blueGrey[900],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                  onPressed: (){
                    //return to home page
                    Provider.of<CurrentPageHandler>(widget.rootContext, listen: false).setPageIndex(homePage.pageIndex);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    child: Text(
                      'Get Pro License',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24
                      ),
                    ),
                  ),
                  style: TextButton.styleFrom(
                      backgroundColor: brandPrimary
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
