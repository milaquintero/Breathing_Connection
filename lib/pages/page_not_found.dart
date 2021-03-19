import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/styles.dart';
import 'package:breathing_connection/widgets/fancy_page.dart';
import 'package:flutter/material.dart';
import 'package:breathing_connection/models/nav_link.dart';
import 'package:provider/provider.dart';
class PageNotFound extends StatelessWidget {
  final BuildContext rootContext;
  final bool hasBottomNav;
  PageNotFound({this.rootContext, this.hasBottomNav});
  @override
  Widget build(BuildContext context) {
    List<NavLink> navLinks;
    NavLink homePage;
    if(hasBottomNav){
      //available nav links from provider
      navLinks = Provider.of<MainData>(rootContext).pages;
      //find home page in main data page links
      homePage = navLinks.firstWhere((page) => page.pageRoute == '/home');
    }
    //screen height
    double screenHeight = MediaQuery.of(context).size.height;
    return FancyPage(
      headerColor: Colors.grey,
      headerPositionTop: screenHeight / 15,
      headerContent: CircleAvatar(
        backgroundColor: Colors.red,
        radius: screenHeight / 10,
        child: Icon(
          Icons.cancel,
          size: screenHeight / 10,
          color: Colors.grey[50],
        ),
      ),
      mainContentHeight: hasBottomNav ? screenHeight / 1.36 : screenHeight / 1.19,
      mainContentColor: brandPrimary,
      mainContent: Row(
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
                  padding: EdgeInsets.only(top: 0),
                  child: Text(
                    'Error',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight / 10,
                        color: Colors.red
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text(
                    'Whoops!',
                    style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[850]
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 28),
                  child: Text(
                    'Page not found',
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.grey[600]
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){
                    //return to home page (bottom nav layout)
                    if(hasBottomNav){
                      Provider.of<CurrentPageHandler>(rootContext, listen: false).setPageIndex(homePage.pageIndex);
                    }
                    //return to root (default home)
                    else{
                      Provider.of<CurrentPageHandler>(rootContext, listen: false).setPageIndex(0);
                      Navigator.pushReplacementNamed(rootContext, '/root');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    child: Text(
                      'Back to Home',
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
