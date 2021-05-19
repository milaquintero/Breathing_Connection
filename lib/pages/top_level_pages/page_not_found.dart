import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/pages/top_level_pages/loading_page.dart';
import 'package:breathing_connection/services/main_data_service.dart';
import 'package:breathing_connection/widgets/fancy_scrollable_page.dart';
import 'package:flutter/material.dart';
import 'package:breathing_connection/models/nav_link.dart';
import 'package:provider/provider.dart';
class PageNotFound extends StatefulWidget {
  final BuildContext rootContext;
  final bool hasBottomNav;
  PageNotFound({this.rootContext, this.hasBottomNav});
  @override
  _PageNotFoundState createState() => _PageNotFoundState();
}

class _PageNotFoundState extends State<PageNotFound> {
  List<NavLink> navLinks;
  NavLink homePage;
  double screenHeight;
  AppTheme appTheme;
  MainData mainData;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //screen height
    screenHeight = MediaQuery.of(context).size.height;
    //selected theme data
    appTheme = Provider.of<CurrentThemeHandler>(context).currentTheme;
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: MainDataService().mainData,
        builder: (context, snapshot){
          if(snapshot.hasData){
            //app main data
            mainData = snapshot.data;
            if(widget.hasBottomNav){
              //available nav links from provider
              navLinks = Provider.of<MainData>(widget.rootContext).pages;
              //find home page in main data page links
              homePage = navLinks.firstWhere((page) => page.pageRoute == '/home');
            }
            return FancyScrollablePage(
              pageTitle: 'Page Not Found',
              appBarColor: appTheme.bgPrimaryColor,
              bgColor: appTheme.errorColor,
              decorationPrimaryColor: appTheme.brandSecondaryColor,
              decorationSecondaryColor: appTheme.brandPrimaryColor,
              appBarHeight: mainData.appBarHeight,
              child: Container(
                margin: EdgeInsets.only(top: 144, left: 20, right: 20),
                padding: EdgeInsets.only(top: 16, bottom: 50, left: 8, right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: appTheme.bgPrimaryColor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        'Error',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenHeight / 11,
                            color: appTheme.textSecondaryColor
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        'Whoops!',
                        style: TextStyle(
                            fontSize: 28,
                            fontStyle: FontStyle.italic,
                            color: appTheme.textSecondaryColor
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 28),
                      child: Text(
                        'Page not found',
                        style: TextStyle(
                            fontSize: 24,
                            color: appTheme.textPrimaryColor
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: (){
                        //return to home page (bottom nav layout)
                        if(widget.hasBottomNav){
                          Provider.of<CurrentPageHandler>(widget.rootContext, listen: false).setPageIndex(homePage.pageIndex);
                        }
                        //return to root (default home)
                        else{
                          Provider.of<CurrentPageHandler>(context, listen: false).setPageIndex(0);
                          Navigator.pushReplacementNamed(context, '/root');
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        child: Text(
                          'Back to Home',
                          style: TextStyle(
                              color: appTheme.textPrimaryColor,
                              fontSize: 24
                          ),
                        ),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: appTheme.brandPrimaryColor
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          else{
            return LoadingPage();
          }
        }
    );
  }
}
