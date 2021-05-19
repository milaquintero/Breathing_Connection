import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/pages/top_level_pages/loading_page.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:breathing_connection/widgets/fancy_scrollable_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final BuildContext rootContext;
  ProfilePage({this.rootContext});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //app theme
  AppTheme appTheme;
  //current user data
  User curUser;
  //app main data
  MainData mainData;
  Widget profileCard({IconData icon, String title, String subtitle}){
    return Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [appTheme.brandAccentColor, Color.lerp(appTheme.brandPrimaryColor, appTheme.brandAccentColor, 0.4), appTheme.brandPrimaryColor],
              center: Alignment(0.6, -0.3),
              focal: Alignment(0.3, -0.1),
              focalRadius: 9.75,
              radius: 0.55
            ),
            borderRadius: BorderRadius.circular(10)
        ),
        child: ListTile(
          contentPadding: EdgeInsets.only(top: 4, left: 16, right: 32, bottom: 4),
          leading: Icon(
            icon,
            size: 36,
            color: appTheme.textPrimaryColor,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: appTheme.textPrimaryColor,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          subtitle: Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: appTheme.textPrimaryColor,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        )
    );
  }
  void signOut() async{
    await UserService().signOut();
    //send back to authentication wrapper
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //app theme
    appTheme = Provider.of<CurrentThemeHandler>(widget.rootContext).currentTheme;
    //app main data
    mainData = Provider.of<MainData>(context);
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: UserService().userWithData,
        builder: (context, snapshot){
          if(snapshot.hasData){
            curUser = snapshot.data;
            return FancyScrollablePage(
              withIconHeader: false,
              pageTitle: 'Profile',
              bgColor: appTheme.bgPrimaryColor,
              appBarColor: appTheme.brandPrimaryColor,
              decorationPrimaryColor: appTheme.decorationPrimaryColor,
              decorationSecondaryColor: appTheme.decorationSecondaryColor,
              appBarHeight: mainData.appBarHeight,
              child: Container(
                margin: EdgeInsets.only(top: 36, bottom: 36),
                padding: EdgeInsets.only(top: 32, left: 36, right: 36, bottom: 24),
                decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [Colors.grey[400], Color.lerp(Colors.blueGrey[900], Colors.black, 0.9), Colors.blueGrey[600]],
                      center: Alignment(0.6, -0.3),
                      focal: Alignment(0.3, -0.1),
                      focalRadius: 4.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Your Information',
                            style: TextStyle(
                                color: appTheme.textPrimaryColor,
                                fontSize: 28
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Divider(
                            color: appTheme.textPrimaryColor,
                          ),
                          SizedBox(height: 20,),
                          Column(
                            children: [
                              profileCard(
                                  icon: Icons.person,
                                  title: 'Your Name',
                                  subtitle: curUser.username
                              ),
                              profileCard(
                                  icon: Icons.account_balance_wallet_rounded,
                                  title: 'Access Type',
                                  subtitle: curUser.hasFullAccess ? 'Full Version' : 'Free Version'
                              ),
                              profileCard(
                                  icon: Icons.email,
                                  title: 'Your Email',
                                  subtitle: curUser.email
                              )
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 8),
                        child: TextButton(
                          onPressed: () {
                            signOut();
                          },
                          child: Text(
                            'Sign Out',
                            style: TextStyle(
                                fontSize: 26,
                                color: Colors.white
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.deepOrange[600],
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          else{
            return LoadingPage();
          }
        }
    );
  }
}
