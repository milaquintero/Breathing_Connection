import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/view_technique_details_handler.dart';
import 'package:breathing_connection/widgets/fancy_instructional_text.dart';
import 'package:breathing_connection/widgets/fancy_scrollable_page.dart';
import 'package:breathing_connection/widgets/fancy_tag.dart';
import 'package:breathing_connection/widgets/fancy_text_container.dart';
import 'package:flutter/material.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:provider/provider.dart';
import 'package:breathing_connection/models/inhale_exhale_type.dart';

class TechniqueDetailsPage extends StatefulWidget {
  @override
  _TechniqueDetailsPageState createState() => _TechniqueDetailsPageState();
}

class _TechniqueDetailsPageState extends State<TechniqueDetailsPage> {
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
  }
  @override
  Widget build(BuildContext context) {
    return FancyScrollablePage(
      headerIconColor: appTheme.textPrimaryColor,
      bgColor: appTheme.bgSecondaryColor,
      pageTitle: 'Technique Details',
      decorationPrimaryColor: appTheme.decorationPrimaryColor,
      decorationSecondaryColor: appTheme.decorationSecondaryColor,
      appBarColor: appTheme.brandPrimaryColor,
      appBarHeight: mainData.appBarHeight,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 32),
            child: Text(
              techniqueToDisplay.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: appTheme.textSecondaryColor
              ),
            ),
          ),
          FancyInstructionalText(
            icon: Icons.analytics,
            iconColor: appTheme.textPrimaryColor,
            iconBgColor: appTheme.brandAccentColor,
            bgColor: appTheme.brandPrimaryColor,
            title: 'Description',
            subtitle: techniqueToDisplay.description,
            textColor: appTheme.textPrimaryColor,
            bgGradientComparisonColor: appTheme.bgAccentColor,
            margin: EdgeInsets.only(top: 72, bottom: 8),
            subtitleAlignment: TextAlign.start,
          ),
          FancyTextContainer(
            icon: Icons.integration_instructions,
            iconColor: appTheme.textPrimaryColor,
            iconBgColor: appTheme.brandAccentColor,
            bgColor: appTheme.brandPrimaryColor,
            bgGradientComparisonColor: appTheme.bgAccentColor,
            title: 'Breathing Rhythm',
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Inhale: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: appTheme.textPrimaryColor
                              )
                          ),
                          Text(
                              '${techniqueToDisplay.inhaleDuration} seconds ',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: appTheme.textPrimaryColor
                              )
                          ),
                          Text(
                              '(${inhaleType.description})',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: appTheme.textPrimaryColor
                              )
                          )
                        ]
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'First Hold: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: appTheme.textPrimaryColor
                              )
                          ),
                          Text(
                              '${techniqueToDisplay.firstHoldDuration} seconds',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: appTheme.textPrimaryColor
                              )
                          )
                        ]
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Exhale: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: appTheme.textPrimaryColor
                              )
                          ),
                          Text(
                              '${techniqueToDisplay.exhaleDuration} seconds ',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: appTheme.textPrimaryColor
                              )
                          ),
                          Text(
                              '(${exhaleType.description})',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: appTheme.textPrimaryColor
                              )
                          )
                        ]
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4, bottom: 12),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Second Hold: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: appTheme.textPrimaryColor
                              )
                          ),
                          Text(
                              '${techniqueToDisplay.secondHoldDuration} seconds',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: appTheme.textPrimaryColor
                              )
                          )
                        ]
                    ),
                  )
                ],
              ),
            ),
            textColor: appTheme.textPrimaryColor,
            margin: EdgeInsets.only(top: 68, bottom: 44),
            subtitleAlignment: TextAlign.justify,
          ),
          FancyTextContainer(
            icon: Icons.pie_chart,
            iconColor: appTheme.textPrimaryColor,
            iconBgColor: appTheme.brandAccentColor,
            bgColor: appTheme.brandPrimaryColor,
            bgGradientComparisonColor: appTheme.bgAccentColor,
            title: 'Tags',
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: techniqueToDisplay.tags.length,
                  itemBuilder: (context, index){
                    return FancyTag(
                      tagName: techniqueToDisplay.tags[index],
                    );
                  }
              ),
            ),
            textColor: appTheme.textPrimaryColor,
            margin: EdgeInsets.only(top: 68, bottom: 44),
            subtitleAlignment: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
