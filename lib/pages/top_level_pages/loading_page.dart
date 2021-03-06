import 'dart:async';
import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/asset_handler.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/nav_link.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/services/main_data_service.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatefulWidget {
  final bool shouldRetrieveMainData;
  LoadingPage({this.shouldRetrieveMainData = false});
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Timer dataRetrievalSuccessTimer;
  //app theme once user data and app data is loaded
  AppTheme selectedTheme;
  //user data
  User curUser;
  //track when all data is retrieved
  Future asyncDataFuture;

  Future <void> getMainData() async{
    //get main data
    MainData mainData = await MainDataService().mainData.first;
    //user data
    curUser = await UserService().userWithData.first;
    //start bottom nav in home page
    NavLink homePageLink = mainData.pages.firstWhere((link){
      return link.pageRoute == '/home';
    }, orElse: null);
    Provider.of<CurrentPageHandler>(context, listen: false).setPageIndex(homePageLink.pageIndex);
  }

  Future getRequiredResources() async{
    //get main data only after user data is present
    await getMainData();
    User curUser = await UserService().userWithData.first;
    //set asset handler URL based on whether user has full access
    Provider.of<AssetHandler>(context, listen: false).init(curUser.hasFullAccess);
    //get user's selected theme based on themeID from user settings
    MainData mainData = await MainDataService().mainData.first;
    selectedTheme = mainData.themes.firstWhere((theme) => theme.themeID == curUser.userSettings.themeID);
    //load user's latest selected theme
    Provider.of<CurrentThemeHandler>(context, listen: false).setCurrentTheme(selectedTheme);
    //set user to root (defaulting to home tab) after 3 seconds
    dataRetrievalSuccessTimer = Timer(Duration(seconds: 5), (){
      Navigator.pushReplacementNamed(context, '/disclaimer-page');
    });
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    dataRetrievalSuccessTimer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    if(widget.shouldRetrieveMainData)
      asyncDataFuture = getRequiredResources();
  }

  @override
  Widget build(BuildContext context) {
    return widget.shouldRetrieveMainData ? FutureBuilder(
        builder: (context, AsyncSnapshot<dynamic> snapshot){
          Widget mainContent;
          //show logo with white background as background when loaded
          if(snapshot.hasData){
            mainContent = Scaffold(
              backgroundColor: selectedTheme.bgPrimaryColor,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    selectedTheme.themeID == 2 ? 'assets/logo-dark.png' : 'assets/logo.png',
                      height: 120,
                      fit: BoxFit.fitHeight,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'Welcome, ${curUser.username}',
                      style: TextStyle(
                        fontSize: 28,
                        color: selectedTheme.textSecondaryColor,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              key: ValueKey(1),
            );
          }
          //show grey background with loading spinner when pending data load
          else{
            mainContent = Scaffold(
              backgroundColor: Colors.blueGrey[400],
              body: Center(
                child: SpinKitDoubleBounce(
                  size: 100,
                  color: Colors.white,
                ),
              ),
              key: ValueKey(0),
            );
          }
          return AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: mainContent,
          );
        },
        future: asyncDataFuture,
    ) : Scaffold(
      backgroundColor: Colors.blueGrey[400],
      body: Center(
        child: SpinKitDoubleBounce(
          size: 100,
          color: Colors.white,
        ),
      ),
      key: ValueKey(0),
    );
  }
}
