import 'dart:async';
import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/asset_handler.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/nav_link.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/services/main_data_service.dart';
import 'package:breathing_connection/services/technique_service.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatefulWidget {
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
  Future<void> getUserData() async{
    //get user data from backend and update shareable resource with user data
    curUser = await UserService.userData(1);
    Provider.of<User>(context, listen: false).setAllProperties(curUser);
  }

  Future<void> getTechniques() async{
    //get list of available techniques
    List<Technique> techniques = await TechniqueService.techniqueData();
    //update techniques in shareable resource
    Provider.of<List<Technique>>(context, listen: false).addAll(techniques);
  }

  Future <void> getMainData() async{
    //get main data
    MainData mainData = await MainDataService.mainData();
    //user data
    curUser = Provider.of<User>(context, listen: false);
    //if user has full access remove pro license page from nav links
    if(curUser.hasFullAccess){
      mainData.pages.removeWhere((page) => page.pageRoute == '/pro');
    }
    //update main data in shareable resource
    Provider.of<MainData>(context, listen: false).setMainData(mainData);
    //start bottom nav in home page
    NavLink homePageLink = mainData.pages.firstWhere((link){
      return link.pageRoute == '/home';
    });
    Provider.of<CurrentPageHandler>(context, listen: false).setPageIndex(homePageLink.pageIndex);
  }

  Future getRequiredResources() async{
    //get current user data
    await getUserData();
    //get available techniques
    await getTechniques();
    //get main data only after user data is present
    await getMainData();
    User curUser = Provider.of<User>(context, listen: false);
    //set asset handler URL based on whether user has full access
    Provider.of<AssetHandler>(context, listen: false).init(curUser.hasFullAccess);
    //get user's selected theme based on themeID from user settings
    MainData mainData = Provider.of<MainData>(context, listen: false);
    selectedTheme = mainData.themes.firstWhere((theme) => theme.themeID == curUser.userSettings.themeID);
    //load user's latest selected theme
    Provider.of<CurrentThemeHandler>(context, listen: false).setCurrentTheme(selectedTheme);
    //set user to root (defaulting to home tab) after 3 seconds
    dataRetrievalSuccessTimer = Timer(Duration(seconds: 5), (){
      Navigator.pushReplacementNamed(context, '/root');
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
    asyncDataFuture = getRequiredResources();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
    );
  }
}
