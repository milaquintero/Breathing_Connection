import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/styles.dart';
import 'package:breathing_connection/widgets/icon_page.dart';
import 'package:flutter/material.dart';
import 'package:breathing_connection/models/nav_link.dart';
import 'package:provider/provider.dart';
class PageNotFound extends StatelessWidget {
  final BuildContext rootContext;
  PageNotFound({this.rootContext});
  @override
  Widget build(BuildContext context) {
    //available nav links from provider
    List<NavLink> navLinks = Provider.of<MainData>(rootContext).pages;
    //find home page in main data page links
    NavLink homePage = navLinks.firstWhere((page) => page.pageRoute == '/home');
    return IconPage(
      headerColor: Colors.grey,
      headerPositionTop: 80,
      headerContent: CircleAvatar(
        backgroundColor: Colors.blue[50],
        radius: 90,
        child: Icon(
          Icons.cancel,
          size: 90,
          color: Colors.red,
        ),
      ),
      mainContentHeight: 600,
      mainContentColor: brandPrimary,
      mainContent: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 260,
            height: 330,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white
            ),
            child: Column(
              children: [
                Text(
                  '404',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 96,
                      color: Colors.grey[850]
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2),
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
                    //return to home page
                    Provider.of<CurrentPageHandler>(rootContext, listen: false).setPageIndex(homePage.pageIndex);
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
