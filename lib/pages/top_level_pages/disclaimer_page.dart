import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/widgets/fancy_split_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisclaimerPage extends StatefulWidget {
  @override
  _DisclaimerPageState createState() => _DisclaimerPageState();
}

class _DisclaimerPageState extends State<DisclaimerPage> {
  //app theme
  AppTheme appTheme;
  //screen height
  double screenHeight;
  //main data
  MainData mainData;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //selected theme data
    appTheme = Provider.of<CurrentThemeHandler>(context).currentTheme;
    //screen height
    screenHeight = MediaQuery.of(context).size.height;
    //app main data
    mainData = Provider.of<MainData>(context);
  }
  @override
  Widget build(BuildContext context) {
    return FancySplitPage(
      headerColor: appTheme.bgPrimaryColor,
      headerContent: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(top: 24, bottom: 32),
            color: appTheme.bgPrimaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    'Disclaimer',
                    style: TextStyle(
                        fontSize: 42,
                        color: appTheme.textAccentColor
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      mainContentHeight: screenHeight / 2.05,
      mainContentColor: appTheme.bgPrimaryColor,
      mainContent: Container(
        padding: EdgeInsets.symmetric(horizontal: 28),
        child: ListView(
          shrinkWrap: true,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: mainData.disclaimerNotes.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    mainData.disclaimerNotes[index],
                    style: TextStyle(
                        fontSize: 20,
                        color: appTheme.textPrimaryColor
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: TextButton(
                onPressed: (){
                  Navigator.of(context).pushReplacementNamed('/root');
                },
                child: Text(
                  'Accept Terms',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey[50]
                  ),
                ),
                style: TextButton.styleFrom(
                    backgroundColor: appTheme.brandPrimaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
