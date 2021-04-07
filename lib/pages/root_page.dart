import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/nav_link.dart';
import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/notification_manager.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/pages/app_settings_page.dart';
import 'package:breathing_connection/pages/page_not_found.dart';
import 'package:breathing_connection/pages/pro_license_page.dart';
import 'package:breathing_connection/pages/technique_list_page.dart';
import 'package:flutter/material.dart';
import 'package:breathing_connection/pages/home_page.dart';
import 'package:provider/provider.dart';

//handle displaying notification when alarm goes off
void alarmCallback(){
  NotificationManager n = new NotificationManager();
  n.initNotificationManager();
  n.showNotification("Time to take a breather", "Your next breathing session begins now");
}

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
  @override
  void initState() {
    super.initState();
    //get user's selected theme based on themeID from user settings
    User curUser = Provider.of<User>(context, listen: false);
    //schedule daily reminders if setting is on
    if(curUser.userSettings.dailyReminders){
      //schedule reminders for AM/PM if challenge mode isn't on or using free version
      if(!curUser.userSettings.challengeMode || !curUser.hasFullAccess){
        int timerId = 0;
        //set alarms for challenge times (three times a day)
        for(DateTime regularTime in curUser.dailyReminderLists.regularTimes){
          DateTime now = DateTime.now();
          AndroidAlarmManager.periodic(
            //repeat every 24 hours in case user doesn't quit the app
            Duration(hours: 24),
            timerId,
            alarmCallback,
            startAt: DateTime(
                now.year,
                now.month,
                now.day,
                regularTime.hour,
                regularTime.minute),
            exact: true,
            wakeup: true
          );
          timerId++;
        }
      }
      //check if user has full version and challenge mode is on
      else{
        int timerId = 0;
        //set alarm for regular times (AM/PM)
        for(DateTime challengeModeTime in curUser.dailyReminderLists.challengeModeTimes){
          DateTime now = DateTime.now();
          AndroidAlarmManager.periodic(
              //repeat every 24 hours in case user doesn't quit the app
              Duration(hours: 24),
              timerId,
              alarmCallback,
              startAt: DateTime(
                  now.year,
                  now.month,
                  now.day,
                  challengeModeTime.hour,
                  challengeModeTime.minute),
              exact: true,
              wakeup: true
          );
          timerId++;
        }
      }
    }
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //app main data
    mainData = Provider.of<MainData>(context);
    //handler for current page (used by bottom nav)
    curPage = Provider.of<CurrentPageHandler>(context);
    //list of links for side nav
    navLinks = List<NavLink>.from(mainData.pages);
    //selected theme data
    appTheme = Provider.of<CurrentThemeHandler>(context).currentTheme;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
