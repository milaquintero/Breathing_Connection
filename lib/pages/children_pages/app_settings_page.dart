import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/services/user_service.dart';
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
          //settings in json format for filtering
          allSettings = curUser.userSettings.toJson();
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
            body: Container(
              child: ListView(
                children: mainContent,
              ),
            ),
          );
        }
        else{
          return SpinKitDualRing(
              color: appTheme.textPrimaryColor,
              size: 32,
          );
        }
      }
    );
  }
  //update user settings
  void updateUserSettings(rootContext, settingKey, newVal){
    //TODO: user firebase to do this
    //get user settings from user provider
    //UserSettings newSettings = Provider.of<User>(rootContext, listen: false).userSettings;
    //edge case for theme (value received as AppTheme)
    /*if(settingKey == 'themeID' && newVal.runtimeType == AppTheme){
      //format selected themeID for valid use
      var tempSelectedTheme = newVal as AppTheme;
      //update current theme handler with new theme
      Provider.of<CurrentThemeHandler>(rootContext, listen: false).setCurrentTheme(tempSelectedTheme);
      //change newVal to just the themeID for update in user settings
      newVal = tempSelectedTheme.themeID;
    }*/
    //update selected setting in temp variable
    //newSettings.setProperty(settingKey, newVal);
    //TODO: user firebase to do this
    //update actual settings in user provider using function that notifies listeners
    //Provider.of<User>(rootContext, listen: false).updateSettings(newSettings);
    //persist changes to settings in backend
    //UserService.handleUpdateSettings(newSettings);
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
            updateUserSettings(widget.rootContext, key, newVal);
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
            updateUserSettings(widget.rootContext, key, newVal);
          },
        )
    );
    //add display settings section
    Iterable<MapEntry<String, dynamic>> displaySettings = filterSettings(
        allSettings,
        ['themeID']
    );
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
          curThemePrimaryColor: appTheme.brandPrimaryColor,
          settingsMap: displaySettings,
          headerTitle: 'Display Settings',
          rootCallback: (key, newVal){
            updateUserSettings(widget.rootContext, key, newVal);
          },
        )
    );
  }
}
