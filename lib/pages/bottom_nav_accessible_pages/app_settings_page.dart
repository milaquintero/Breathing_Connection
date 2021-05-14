import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/daily_reminder_lists.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/models/user_settings.dart';
import 'package:breathing_connection/pages/top_level_pages/loading_page.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:breathing_connection/widgets/dialog_alert.dart';
import 'package:breathing_connection/widgets/dialog_daily_reminder_time_picker.dart';
import 'package:breathing_connection/widgets/setting_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utility.dart';

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
  //temp user settings to track changes
  UserSettings newSettings;
  //temp daily reminder list to track changes
  DailyReminderLists tempDailyReminderLists;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //app main data
    mainData = Provider.of<MainData>(context);
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
          //daily reminders haven't changed so load from current user
          if(!DailyReminderLists.haveChanged(tempDailyReminderLists, curUser.dailyReminderLists)){
            tempDailyReminderLists = curUser.dailyReminderLists;
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
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if(UserSettings.settingsThatChanged(newSettings, curUser.userSettings).length != 0 ||
                    DailyReminderLists.haveChanged(tempDailyReminderLists, curUser.dailyReminderLists)) Container(
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [Colors.deepOrange[800], Color.lerp(Colors.deepOrange[900], Colors.deepOrange[900], 0.1), Colors.deepOrange[800]],                        center: Alignment(-10.5, 0.8),
                        focal: Alignment(0.3, -0.1),
                        focalRadius: 0.8,
                      ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    leading: Icon(
                      Icons.info,
                      size: 32,
                      color: appTheme.textPrimaryColor,
                    ),
                    title: Text(
                      'Unsaved changes detected',
                      style: TextStyle(
                        fontSize: 24,
                        color: appTheme.textPrimaryColor,
                      ),
                    ),
                  ),
                ),
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
  void showSuccessMessage() async{
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
  //update user settings
  void updateUserSettings(rootContext) async{
    //make sure settings have changed before updating in firestore
    List<String> settingsThatChanged = UserSettings.settingsThatChanged(newSettings, curUser.userSettings);
    if(settingsThatChanged.length != 0){
      //update settings in firestore
      await UserService(uid: curUser.userId).handleUpdateSettings(newSettings);
      if(settingsThatChanged.contains("themeID")){
        AppTheme selectedTheme = mainData.themes.firstWhere((theme) => newSettings.themeID == theme.themeID);
        //update selected theme in provider if it changed
        Provider.of<CurrentThemeHandler>(rootContext, listen: false).setCurrentTheme(selectedTheme);
        //update theme in this page for immediate rebuild
        setState(() {
          appTheme = selectedTheme;
        });
      }
      //handle case if daily reminders or challenge mode have been turned on/off
      if(settingsThatChanged.contains("dailyReminders") || settingsThatChanged.contains("challengeMode")){
        //set updated settings for daily reminders and challenge mode
        curUser.userSettings.dailyReminders = newSettings.dailyReminders;
        curUser.userSettings.challengeMode = newSettings.challengeMode;
        //cancel all previous alarms
        Utility.cancelAllAlarms();
        //handle setting alarms for daily reminders/challenge mode if they're turned on
        Utility.scheduleDailyReminders(curUser, mainData);
      }
      showSuccessMessage();
    }
    else if(DailyReminderLists.haveChanged(tempDailyReminderLists, curUser.dailyReminderLists)){
      UserService(uid: curUser.userId).handleUpdateDailyReminderLists(tempDailyReminderLists);
      //cancel all previous alarms
      Utility.cancelAllAlarms();
      //update user's daily reminders locally before rescheduling alarms
      curUser.dailyReminderLists = tempDailyReminderLists;
      //set new alarms
      Utility.scheduleDailyReminders(curUser, mainData);
      showSuccessMessage();
    }
  }

  Iterable<MapEntry<String, dynamic>> filterSettings(Map<String, dynamic> allSettings, List<String>desiredKeys){
    return allSettings.entries.where(
            (setting) => desiredKeys.contains(setting.key)
    );
  }
  
  void openEmailApp() async{
    if(await canLaunch("mailto:${mainData.supportEmail}")){
      //open native mail app with support email in the TO
      await launch("mailto:${mainData.supportEmail}");
    }
    else{
      //no native mail app is installed so show dialog that gives them the support email & instructions
      await showDialog(
          context: context,
          builder: (context){
            return DialogAlert(
              titlePadding: EdgeInsets.only(top: 12),
              subtitlePadding: EdgeInsets.only(top: 16, bottom: 28, left: 24, right: 24),
              buttonText: 'Back to Settings',
              cbFunction: (){},
              titleText: 'Contact Support',
              subtitleText: 'No native mail app was found on your device. Please contact support using your browser via email directed towards the following address: ${mainData.supportEmail}',
              headerIcon: Icons.support_agent,
              headerBgColor: appTheme.brandPrimaryColor,
              buttonColor: appTheme.brandPrimaryColor,
              titleTextColor: appTheme.textAccentColor,
              bgColor: appTheme.bgPrimaryColor,
              subtitleTextColor: appTheme.textAccentColor,
            );
          }
      );
    }
  }

  void unsubscribeFromPro() async{
    await showDialog(
        context: context,
        builder: (context){
      return DialogAlert(
        titlePadding: EdgeInsets.only(top: 12),
        subtitlePadding: EdgeInsets.only(top: 16, bottom: 28, left: 24, right: 24),
        buttonText: 'Go to Google Play',
        cbFunction: () async{
          String appPackageName = "com.hylicmerit.breathing_connection";
          try {
            launch("market://details?id=" + appPackageName);
          } on PlatformException {
            launch("https://play.google.com/store/apps/details?id=" + appPackageName);
          } finally {
            launch("https://play.google.com/store/apps/details?id=" + appPackageName);
          }
        },
        titleText: 'End Pro License',
        subtitleText: 'To end your subscription, you must unsubscribe in the Google Play Score. Once you click the button below, go to the subscription settings for Breathing Connection and end it there. Best of luck in your breathing journey!',
        headerIcon: Icons.assistant_direction,
        headerBgColor: appTheme.brandPrimaryColor,
        buttonColor: appTheme.brandPrimaryColor,
        titleTextColor: appTheme.textAccentColor,
        bgColor: appTheme.bgPrimaryColor,
        subtitleTextColor: appTheme.textAccentColor,
      );
    }
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
    //add card to edit daily reminder times
    mainContent.add(
        Container(
          decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: appTheme.cardBorderColor,
                    width: 1.5
                ),
              ),
              gradient: RadialGradient(
                colors: [Colors.blueGrey, Color.lerp(appTheme.cardBgColor, Colors.blueGrey, 0.25), appTheme.cardBgColor],
                center: Alignment(0.6, -0.3),
                focal: Alignment(0.3, -0.1),
                focalRadius: 12.5,
              )
          ),
          child: Container(
            margin: EdgeInsets.zero,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 36),
              leading: Icon(
                Icons.account_balance_wallet_outlined,
                size: 32,
                color: appTheme.cardTitleColor,
              ),
              title: Text(
                'Edit Reminders',
                style: TextStyle(
                    fontSize: 28,
                    color: appTheme.textAccentColor
                ),
              ),
              trailing: GestureDetector(
                onTap: (){
                  //handle changing theme with selection dialog
                  if(curUser != null && curUser.dailyReminderLists != null){
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context){
                          return DialogDailyReminderTimePicker(
                            titlePadding: EdgeInsets.only(top: 24, bottom: 6),
                            headerIcon: Icons.timelapse_rounded,
                            headerBgColor: appTheme.brandPrimaryColor,
                            dailyReminderLists: tempDailyReminderLists,
                            userHasFullAccess: curUser.hasFullAccess,
                            buttonColor: appTheme.brandPrimaryColor,
                            cardColor: appTheme.cardBgColor,
                            textColor: appTheme.textSecondaryColor,
                            timeDisplayTextColor: appTheme.textPrimaryColor,
                            dialogBgColor: appTheme.bgPrimaryColor,
                            timeDisplayBgColor: appTheme.bgAccentColor,
                            timeDisplayGradientComparisonColor: appTheme.brandAccentColor,
                            timePickerBgColor: appTheme.bgPrimaryColor,
                            cbFunction: (String op, int index, Timestamp newTime){
                              //update selected daily reminder list entry based on operation and index
                              setState(() {
                                if(op == 'regularTimes'){
                                  tempDailyReminderLists.regularTimes[index] = newTime;
                                }
                                else if(op == 'challengeModeTimes'){
                                  tempDailyReminderLists.challengeModeTimes[index] = newTime;
                                }
                              });
                            },
                          );
                        }
                    );
                  }
                },
                child: Container(
                  width: 53,
                  height: 50,
                  child: Material(
                    elevation: 2,
                    color: Colors.transparent,
                    shape: CircleBorder(),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: appTheme.brandPrimaryColor,
                          shape: BoxShape.circle
                      ),
                      child: Icon(
                        Icons.settings_rounded,
                        color: appTheme.textPrimaryColor,
                        size: 28
                      )
                    ),
                  ),
                ),
              ),
            ),
          ),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Email Subscriptions',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: appTheme.textPrimaryColor,
                      fontSize: 30,
                    ),
                ),
                SizedBox(width: 10,),
                Icon(
                  Icons.settings_rounded,
                  size: 32,
                  color: appTheme.textPrimaryColor,
                )
              ],
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: appTheme.brandPrimaryColor,
            shape: ContinuousRectangleBorder()
          ),
      ),
    );
    //add button to contact support
    mainContent.add(
      TextButton(
        onPressed: (){
          openEmailApp();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Contact Support',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appTheme.textPrimaryColor,
                  fontSize: 30,
                ),
              ),
              SizedBox(width: 10,),
              Icon(
                Icons.support_agent,
                size: 32,
                color: appTheme.textPrimaryColor,
              )
            ],
          ),
        ),
        style: TextButton.styleFrom(
            backgroundColor: appTheme.brandSecondaryColor,
            shape: ContinuousRectangleBorder()
        ),
      ),
    );
    if(curUser.hasFullAccess){
      //add button to unsubscribe from pro version
      mainContent.add(
        TextButton(
          onPressed: (){
            unsubscribeFromPro();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'End Pro License',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appTheme.textPrimaryColor,
                    fontSize: 30,
                  ),
                ),
                SizedBox(width: 10,),
                Icon(
                  Icons.support_agent,
                  size: 32,
                  color: appTheme.textPrimaryColor,
                )
              ],
            ),
          ),
          style: TextButton.styleFrom(
              backgroundColor: appTheme.errorColor,
              shape: ContinuousRectangleBorder()
          ),
        ),
      );
    }
  }
}
