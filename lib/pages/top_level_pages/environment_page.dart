import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/inhale_exhale_type.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/models/view_technique_details_handler.dart';
import 'package:breathing_connection/widgets/fancy_split_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class EnvironmentPage extends StatefulWidget {
  @override
  _EnvironmentPageState createState() => _EnvironmentPageState();
}

class _EnvironmentPageState extends State<EnvironmentPage> {
  //technique data to display
  Technique techniqueToDisplay;
  //app main data
  MainData mainData;
  //exhale type for selected technique
  InhaleExhaleType inhaleType;
  //inhale type for selected technique
  InhaleExhaleType exhaleType;
  //app theme data
  AppTheme appTheme;
  //current user
  User curUser;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //get technique data
    techniqueToDisplay = Provider.of<ViewTechniqueDetailsHandler>(context).techniqueBeingViewed;
    //get inhale/exhale data from list in main data based on inhaleExhaleTypeID
    mainData = Provider.of<MainData>(context);
    inhaleType = mainData.inhaleExhaleTypes.firstWhere((inhaleExhaleType) => inhaleExhaleType.inhaleExhaleTypeID == techniqueToDisplay.inhaleTypeID);
    exhaleType = mainData.inhaleExhaleTypes.firstWhere((inhaleExhaleType) => inhaleExhaleType.inhaleExhaleTypeID == techniqueToDisplay.exhaleTypeID);
    //selected theme data
    appTheme = Provider.of<CurrentThemeHandler>(context).currentTheme;
    //current user data
    curUser = Provider.of<User>(context);
  }
  @override
  Widget build(BuildContext context) {
    return FancySplitPage(

    );
  }
}
