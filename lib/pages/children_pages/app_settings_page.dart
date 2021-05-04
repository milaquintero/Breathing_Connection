import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/models/user_settings.dart';
import 'package:breathing_connection/pages/top_level_pages/loading_page.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:breathing_connection/widgets/dialog_alert.dart';
import 'package:breathing_connection/widgets/setting_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AppSettingsPage extends StatefulWidget {
  final BuildContext rootContext;
  AppSettingsPage({this.rootContext});
  @override
  _AppSettingsPageState createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  //selected theme data
  AppTheme appTheme;
  //settings in json format for filtering
  Map <String, dynamic> allSettings;
  //set up main content
  List<Widget> mainContent = [];
  //app main data
  MainData mainData;
  //current user
  User curUser;
  //user service
  UserService _userService = UserService();
  //temp user settings to track changes
  UserSettings newSettings;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //app main data
    mainData = Provider.of<MainData>(widget.rootContext);
    //selected theme data
    appTheme = Provider.of<CurrentThemeHandler>(widget.rootContext).currentTheme;
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: UserService().userWithData,
      builder: (context, userSnapshot){
        if(userSnapshot.hasData){
          curUser = userSnapshot.data;
          if(UserSettings.settingsThatChanged(newSettings, curUser.userSettings).length != 0){
            //settings in json format for filtering
            allSettings = newSettings.toJson();
          }
          else{
            //set temp user settings to current user settings
            newSettings = curUser.userSettings;
            //settings in json format for filtering
            allSettings = curUser.userSettings.toJson();
          }
          //build sections on init
          buildSettingSections();
          return Scaffold(
            appBar: AppBar(
              backgroundColor: appTheme.brandPrimaryColor,
              toolbarHeight: mainData.appBarHeight,
              title: Text(
                'App Settings',
                style: TextStyle(
                    fontSize: 30
                ),
              ),
              centerTitle: true,
              elevation: 0,
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.logout,
                      size: 32,
                    ),
                    onPressed: () async{
                      await _userService.signOut();
                      //send back to authentication wrapper
                      Navigator.pushReplacementNamed(context, '/');
                    }
                ),
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    child: ListView(
                      shrinkWrap: true,
                      children: mainContent,
                    ),
                  ),
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [Colors.blueGrey[400], Color.lerp(appTheme.bgAccentColor, Colors.blueGrey[400], 0.01), appTheme.bgAccentColor],
                        center: Alignment(-10.5, 0.8),
                        focal: Alignment(0.3, -0.1),
                        focalRadius: 500.5,
                      )
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    onTap: (){
                      //update user settings in firestore
                      updateUserSettings(widget.rootContext);
                    },
                    title: Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                              left: -100,
                              top: -120,
                              child: Container(
                                height: 450,
                                width: 450,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(300),
                                  color: Colors.green[700],
                                  gradient: RadialGradient(
                                    colors: [Colors.green[600], Color.lerp(Colors.green[500], Colors.blueGrey[500], 0.1), Colors.green[600]],
                                    center: Alignment(0.6, 0.3),
                                    focal: Alignment(0.3, -0.1),
                                    focalRadius: 0.8,
                                  ),
                                ),
                              )
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: appTheme.textPrimaryColor,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Icon(
                                Icons.save,
                                size: 32,
                                color: appTheme.textPrimaryColor,
                              )
                            ],
                          )
                        ]
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        else{
          return LoadingPage();
        }
      }
    );
  }
  //update user settings
  void updateUserSettings(rootContext) async{
    //make sure settings have changed before updating in firestore
    List<String> settingsThatChanged = UserSettings.settingsThatChanged(newSettings, curUser.userSettings);
    if(settingsThatChanged.length != 0){
      //update settings in firestore
      await UserService().handleUpdateSettings(curUser.userId, newSettings);
      if(settingsThatChanged.contains("themeID")){
        AppTheme selectedTheme = mainData.themes.firstWhere((theme) => newSettings.themeID == theme.themeID);
        //update selected theme in provider if it changed
        Provider.of<CurrentThemeHandler>(rootContext, listen: false).setCurrentTheme(selectedTheme);
        //update theme in this page for immediate rebuild
        setState(() {
          appTheme = selectedTheme;
        });
      }
      await showDialog(
          context: context,
          builder: (context){
            return DialogAlert(
              titlePadding: EdgeInsets.only(top: 12),
              subtitlePadding: EdgeInsets.only(top: 16, bottom: 28, left: 24, right: 24),
              buttonText: 'Back to Settings',
              cbFunction: (){},
              titleText: 'Success',
              subtitleText: 'Changes to these settings have been saved in your account',
              headerIcon: Icons.fact_check,
              headerBgColor: Colors.green[600],
              buttonColor: appTheme.brandPrimaryColor,
              titleTextColor: appTheme.textAccentColor,
              bgColor: appTheme.bgPrimaryColor,
              subtitleTextColor: appTheme.textAccentColor,
            );
          }
      );
    }
  }

  Iterable<MapEntry<String, dynamic>> filterSettings(Map<String, dynamic> allSettings, List<String>desiredKeys){
    return allSettings.entries.where(
            (setting) => desiredKeys.contains(setting.key)
    );
  }

  void buildSettingSections(){
    //reset main content
    mainContent = [];
    //if user has full access, add challenge mode setting to general settings
    List<String> generalSettingsFilters = ['dailyReminders'];
    if(curUser.hasFullAccess){
      generalSettingsFilters.add('challengeMode');
    }
    //add general settings section
    Iterable<MapEntry<String, dynamic>> generalSettings = filterSettings(
        allSettings,
        generalSettingsFilters
    );
    mainContent.add(
        SettingSection(
          headerBgColor: appTheme.brandSecondaryColor,
          headerTextColor: appTheme.textPrimaryColor,
          settingsMap: generalSettings,
          headerTitle: 'General Settings',
          cardTextColor: appTheme.textAccentColor,
          cardBgColor: appTheme.cardBgColor,
          cardBorderColor: appTheme.cardBorderColor,
          headerDecorationColor: appTheme.bgAccentColor,
          cardIconColor: appTheme.cardTitleColor,
          cardActionColor: appTheme.cardActionColor,
          rootCallback: (key, newVal){
            setState(() {
              newSettings.setProperty(key, newVal);
            });
          },
        )
    );
    //add sound settings section
    Iterable<MapEntry<String, dynamic>> soundSettings = filterSettings(
        allSettings,
        ['breathingSound', 'backgroundSound', 'vibration']
    );
    mainContent.add(
        SettingSection(
          headerBgColor: appTheme.brandSecondaryColor,
          headerTextColor: appTheme.textPrimaryColor,
          cardTextColor: appTheme.textAccentColor,
          cardBgColor: appTheme.cardBgColor,
          cardBorderColor: appTheme.cardBorderColor,
          headerDecorationColor: appTheme.bgAccentColor,
          cardIconColor: appTheme.cardTitleColor,
          cardActionColor: appTheme.cardActionColor,
          settingsMap: soundSettings,
          headerTitle: 'Sound Settings',
          rootCallback: (key, newVal){
            setState(() {
              newSettings.setProperty(key, newVal);
            });
          },
        )
    );
    //add display settings section
    Iterable<MapEntry<String, dynamic>> displaySettings = filterSettings(
        allSettings,
        ['themeID']
    );
    //get latest selection for theme
    AppTheme latestSelectedTheme = mainData.themes.firstWhere((theme) => theme.themeID == newSettings.themeID);
    mainContent.add(
        SettingSection(
          headerBgColor: appTheme.brandSecondaryColor,
          headerTextColor: appTheme.textPrimaryColor,
          cardTextColor: appTheme.cardTitleColor,
          cardBgColor: appTheme.cardBgColor,
          cardBorderColor: appTheme.cardBorderColor,
          cardIconColor: appTheme.cardTitleColor,
          cardActionColor: appTheme.cardActionColor,
          headerDecorationColor: appTheme.bgAccentColor,
          selectionList: mainData.themes,
          curThemePrimaryColor: latestSelectedTheme.brandPrimaryColor,
          settingsMap: displaySettings,
          headerTitle: 'Display Settings',
          rootCallback: (key, newVal){
            setState(() {
              newSettings.setProperty(key, newVal);
            });
          },
        )
    );
    //add button to manage email subscriptions
    mainContent.add(
      TextButton(
          onPressed: (){
            Navigator.of(context).pushReplacementNamed("/email-subscription");
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text(
                'Manage Email Subscriptions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appTheme.textPrimaryColor,
                  fontSize: 28
                ),
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: appTheme.brandPrimaryColor,
            shape: ContinuousRectangleBorder()
          ),
      ),
    );
  }
}
