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

class _RootPageState extends State<RootPage> with TickerProviderStateMixin{
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
  //page to display
  Widget _pageToDisplay;
  Offset _transitionOffset;
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
  void dispose() {
    super.dispose();
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
    //handle switching page with animation
    int currentIndex = curPage.pageIndex;
    String currentRoute = navLinks[currentIndex].pageRoute;
    setState(() {
      if(currentRoute == '/home'){
        _pageToDisplay = HomePage(rootContext: context,);
        _transitionOffset = Offset(-1.5,0.0);
      }
      else if(currentRoute == '/technique-list'){
        _pageToDisplay = TechniqueListPage(rootContext: context);
        _transitionOffset = Offset(1.5,0.0);
      }
      else if(currentRoute == '/settings'){
        _pageToDisplay = AppSettingsPage(rootContext: context,);
        _transitionOffset = Offset(-1.5,0.0);
      }
      else if(currentRoute == '/pro'){
        _pageToDisplay = ProLicensePage(rootContext: context,);
        _transitionOffset = Offset(1.5,0.0);
      }
      else{
        _pageToDisplay = PageNotFound(rootContext: context, hasBottomNav: true,);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: UserService().userWithData,
      child: Scaffold(
        backgroundColor: appTheme.brandPrimaryColor,
        body: AnimatedSwitcher(
          transitionBuilder: (Widget child, Animation<double> animation) {
            return DualTransitionBuilder(
              animation: animation,
              forwardBuilder: (BuildContext context, Animation<double> animation, Widget child){
                final  customAnimation =
                Tween<Offset>(begin: _transitionOffset, end: Offset.zero).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic)
                );
                return SlideTransition(position: customAnimation, child: child,);
              },
              reverseBuilder: (BuildContext context, Animation<double> animation, Widget child){
                final  customAnimation =
                Tween<double>(begin: 1.0, end: 1.0).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInSine)
                );
                return FadeTransition(opacity: customAnimation, child: child,);
              },
              child: child,
            );
          },
          duration: Duration(seconds: 1),
          child: _pageToDisplay,
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
