import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/pages/top_level_pages/page_not_found.dart';
import 'package:breathing_connection/services/technique_service.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import '../../main.dart';
import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/nav_link.dart';
import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/user.dart';
import '../children_pages/app_settings_page.dart';
import '../children_pages/home_page.dart';
import '../children_pages/pro_license_page.dart';
import '../children_pages/technique_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  //app main data
  MainData mainData;
  //handler for current page (used by bottom nav)
  CurrentPageHandler curPage;
  //list of links for side nav
  List<NavLink> navLinks;
  //app theme data
  AppTheme appTheme;
  //current user
  User curUser;
  //set a reminder
  void setReminder({int timerId, Function callback, DateTime timeToStart}) async{
    await AndroidAlarmManager.periodic(
      //repeat every 24 hours in case user doesn't quit the app
        Duration(hours: 24),
        timerId,
        callback,
        startAt: timeToStart,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true
    );
  }
  Future<void> getUserWithData() async{
    curUser = await UserService().userWithData.first;
  }
  Future<void> initWithDependencies() async{
    //get user's selected theme based on themeID from user settings
    await getUserWithData();
    //schedule daily reminders if setting is on
    if(curUser.userSettings.dailyReminders){
      //schedule reminders for AM/PM if challenge mode isn't on or using free version
      if(!curUser.userSettings.challengeMode || !curUser.hasFullAccess){
        //timer id
        int timerId = 0;
        //set alarms for challenge times (three times a day)
        for(Timestamp regularTimestamp in curUser.dailyReminderLists.regularTimes){
          DateTime now = DateTime.now();
          DateTime regularTime = regularTimestamp.toDate();
          BreathingConnection.setNotificationText(
              header: mainData.dailyReminderHeader,
              footer: mainData.dailyReminderFooter
          );
          setReminder(
              timerId: timerId,
              timeToStart: DateTime(
                  now.year,
                  now.month,
                  now.day,
                  regularTime.hour,
                  regularTime.minute),
              callback: BreathingConnection.showNotification
          );
          timerId++;
        }
      }
      //check if user has full version and challenge mode is on
      else{
        //timer id
        int timerId = 0;
        //set alarm for regular times (AM/PM)
        for(Timestamp challengeModeTimestamp in curUser.dailyReminderLists.challengeModeTimes){
          DateTime now = DateTime.now();
          DateTime challengeModeTime = challengeModeTimestamp.toDate();
          BreathingConnection.setNotificationText(
              header: mainData.challengeReminderHeader,
              footer: mainData.challengeReminderFooter
          );
          setReminder(
              timerId: timerId,
              timeToStart: DateTime(
                  now.year,
                  now.month,
                  now.day,
                  challengeModeTime.hour,
                  challengeModeTime.minute),
              callback: BreathingConnection.showNotification
          );
          timerId++;
        }
      }
    }
  }
  @override
  void initState(){
    super.initState();
    //app main data
    mainData = Provider.of<MainData>(context, listen: false);
    //initial setup with async dependencies
    initWithDependencies();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //handler for current page (used by bottom nav)
    curPage = Provider.of<CurrentPageHandler>(context);
    //list of links for side nav
    navLinks = List<NavLink>.from(mainData.pages);
    //selected theme data
    appTheme = Provider.of<CurrentThemeHandler>(context).currentTheme;
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: UserService().userWithData,
      child: Scaffold(
        body: Builder(
          builder: (context){
            int currentIndex = curPage.pageIndex;
            String currentRoute = navLinks[currentIndex].pageRoute;
            if(currentRoute == '/home'){
              return HomePage(rootContext: context,);
            }
            else if(currentRoute == '/technique-list'){
              return TechniqueListPage(rootContext: context);
            }
            else if(currentRoute == '/settings'){
              return AppSettingsPage(rootContext: context,);
            }
            else if(currentRoute == '/pro'){
              return ProLicensePage(rootContext: context,);
            }
            else{
              return PageNotFound(rootContext: context, hasBottomNav: true,);
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: curPage.pageIndex,
          elevation: 0,
          backgroundColor: appTheme.bottomNavBgColor,
          type : BottomNavigationBarType.fixed,
          selectedItemColor: appTheme.textSecondaryColor,
          unselectedItemColor: appTheme.disabledCardBorderColor,
          items: navLinks.map((link)=> BottomNavigationBarItem(
              icon: Icon(link.pageIcon),
              label: link.pageTitle
          )
          ).toList(),
          onTap: (index){
            Provider.of<CurrentPageHandler>(context, listen: false).setPageIndex(index);
          },
        ),
      ),
    );
  }
}
