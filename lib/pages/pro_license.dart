import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/styles.dart';
import 'package:breathing_connection/widgets/icon_page.dart';
import 'package:flutter/material.dart';
import 'package:breathing_connection/models/nav_link.dart';
import 'package:provider/provider.dart';
class ProLicense extends StatefulWidget {
  final BuildContext rootContext;
  ProLicense({this.rootContext});

  @override
  _ProLicenseState createState() => _ProLicenseState();
}

class _ProLicenseState extends State<ProLicense> {
  @override
  Widget build(BuildContext context) {
    //available nav links from provider
    List<NavLink> navLinks = Provider.of<MainData>(widget.rootContext).pages;
    //find home page in main data page links
    NavLink homePage = navLinks.firstWhere((page) => page.pageRoute == '/home');
    return IconPage(
      emptySpaceColor: Colors.grey,
      headerColor: Colors.blue[50],
      headerPositionTop: 80,
      headerRadiusSize: 90,
      headerContent: Icon(
        Icons.add_moderator,
        size: 90,
        color: brandPrimary,
      ),
      mainContentHeight: 600,
      mainContentColor: brandPrimary,
      mainContent:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 260,
            height: 320,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Breathe In',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 42,
                        color: Colors.grey[850]
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 28),
                  child: Text(
                    'Gain access to all of Breathing Connection\'s features to immerse yourself in our environment!',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600]
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
