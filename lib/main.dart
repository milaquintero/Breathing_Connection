import 'dart:async';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:breathing_connection/models/asset_handler.dart';
import 'package:breathing_connection/models/notification_manager.dart';
import 'package:breathing_connection/models/route_arguments.dart';
import 'package:breathing_connection/pages/authentication_pages/subscription_store.dart';
import 'package:breathing_connection/pages/authentication_wrapper.dart';
import 'package:breathing_connection/pages/top_level_pages/disclaimer_page.dart';
import 'package:breathing_connection/pages/top_level_pages/environment_page.dart';
import 'package:breathing_connection/services/main_data_service.dart';
import 'package:breathing_connection/services/technique_service.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
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
  //required if platform is android
  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }
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
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CurrentPageHandler()),
        ChangeNotifierProvider(create: (context)=> ViewTechniqueDetailsHandler()),
        ChangeNotifierProvider(create: (context)=>CurrentThemeHandler()),
        ChangeNotifierProvider(create: (context)=>AssetHandler()),
        ChangeNotifierProvider(create: (context)=>SubscriptionStore()),
        StreamProvider<List<Technique>>.value(value: TechniqueService().techniqueList, initialData: []),
        StreamProvider<User>.value(value: UserService().userWithData, initialData: null),
        StreamProvider<MainData>.value(value: MainDataService().mainData, initialData: null,),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onUnknownRoute: (settings){
          return MaterialPageRoute(
              builder: (context)=>Scaffold(
                body: PageNotFound(rootContext: context, hasBottomNav: false,),
              )
          );
        },
        onGenerateRoute: (settings){
          Widget selectedPage;
          final RouteArguments arguments = settings.arguments as RouteArguments;
          switch(settings.name){
            case '/':
              selectedPage = AuthenticationWrapper();
              break;
            case '/root':
              selectedPage = RootPage();
              break;
            case '/email-subscription':
              selectedPage = EmailSubscriptionPage();
              break;
            case '/create-custom-technique':
              selectedPage = CreateCustomTechniquePage(
                isEditing: arguments?.isEditing ?? false,
                selectedTechnique: arguments?.selectedTechnique ?? null,
              );
              break;
            case '/technique-details':
              selectedPage = TechniqueDetailsPage();
              break;
            case '/disclaimer-page':
              selectedPage = DisclaimerPage();
              break;
            case '/environment':
              selectedPage = EnvironmentPage();
              break;
            default:
              selectedPage = PageNotFound(rootContext: context, hasBottomNav: false,);
              break;
          }
          return PageRouteBuilder(
              pageBuilder: (context, primaryAnimation, secondaryAnimation) => selectedPage,
              transitionsBuilder: (context, primaryAnimation, secondaryAnimation, child){
                final  customAnimation =
                Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: primaryAnimation,
                        curve: Curves.easeInSine
                    )
                );
                return FadeTransition(
                    opacity: customAnimation,
                    child: child,
                );
              }
          );
        },
        theme: ThemeData(
          fontFamily: 'ZillaSlab'
        ),
      )
    );
  }
}
