import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:breathing_connection/models/asset_handler.dart';
import 'package:breathing_connection/models/notification_manager.dart';
import 'package:breathing_connection/pages/authentication_wrapper.dart';
import 'package:breathing_connection/services/technique_service.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/current_theme_handler.dart';
import 'models/main_data.dart';
import 'models/current_page_handler.dart';
import 'models/user.dart';
import 'pages/top_level_pages/create_custom_technique_page.dart';
import 'pages/top_level_pages/email_subscription_page.dart';
import 'pages/top_level_pages/page_not_found.dart';
import 'pages/top_level_pages/root_page.dart';
import 'pages/top_level_pages/technique_details_page.dart';
import 'models/technique.dart';
import 'models/view_technique_details_handler.dart';

/// Global [SharedPreferences] object.
SharedPreferences prefs;
/// The [SharedPreferences] keys to access the notification header and footer.
const String notificationHeaderKey = 'header';
const String notificationFooterKey = 'footer';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  //set defaults to empty string for notifications
  if (!prefs.containsKey(notificationHeaderKey)) {
    await prefs.setString(notificationHeaderKey, "");
  }
  if (!prefs.containsKey(notificationFooterKey)) {
    await prefs.setString(notificationFooterKey, "");
  }
  runApp(BreathingConnection());
}

class BreathingConnection extends StatefulWidget {
  static Future<void> setNotificationText({String header, String footer}) async {
    final prefs = await SharedPreferences.getInstance();
    // Ensure we've loaded the latest data from the background isolate.
    await prefs.reload();
    //set header and footer in shared preferences
    String currentHeader = header ?? "";
    await prefs.setString(notificationHeaderKey, currentHeader);
    String currentFooter = footer ?? "";
    await prefs.setString(notificationFooterKey, currentFooter);
  }
  static Future<void> showNotification()async{
    //get header and footer for notification
    final prefs = await SharedPreferences.getInstance();
    String notificationHeader = prefs.getString(notificationHeaderKey) ?? "";
    String notificationFooter = prefs.getString(notificationFooterKey) ?? "";
    //show notification
    NotificationManager nm = NotificationManager();
    nm.initNotificationManager();
    nm.showNotification(notificationHeader, notificationFooter);

  }
  @override
  _BreathingConnectionState createState() => _BreathingConnectionState();
}

class _BreathingConnectionState extends State<BreathingConnection> {
  @override
  void initState(){
    super.initState();
    AndroidAlarmManager.initialize();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MainData>(create: (context) => MainData()),
        ChangeNotifierProvider(create: (context) => CurrentPageHandler()),
        ChangeNotifierProvider(create: (context)=> ViewTechniqueDetailsHandler()),
        ChangeNotifierProvider(create: (context)=>CurrentThemeHandler()),
        ChangeNotifierProvider(create: (context)=>AssetHandler()),
        StreamProvider<List<Technique>>.value(value: TechniqueService().techniqueList, initialData: []),
        StreamProvider<User>.value(value: UserService().userWithData, initialData: null)
      ],
      child: MaterialApp(
        onUnknownRoute: (settings){
          return MaterialPageRoute(
              builder: (context)=>Scaffold(
                body: PageNotFound(rootContext: context, hasBottomNav: false,),
              )
          );
        },
        routes: {
          '/': (context)=>AuthenticationWrapper(),
          '/root': (context)=>RootPage(),
          '/email-subscription': (context)=>EmailSubscriptionPage(),
          '/create-custom-technique': (context)=>CreateCustomTechniquePage(),
          '/technique-details': (context)=>TechniqueDetailsPage(),
        },
        theme: ThemeData(
          fontFamily: 'ZillaSlab'
        ),
      )
    );
  }
}
