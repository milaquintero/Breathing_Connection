import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/route_arguments.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/models/view_technique_details_handler.dart';
import 'package:breathing_connection/services/main_data_service.dart';
import 'package:breathing_connection/services/technique_service.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:breathing_connection/widgets/dialog_prompt.dart';
import 'package:breathing_connection/widgets/fancy_instructional_text.dart';
import 'package:breathing_connection/widgets/fancy_scrollable_page.dart';
import 'package:breathing_connection/widgets/fancy_tag.dart';
import 'package:breathing_connection/widgets/fancy_text_container.dart';
import 'package:flutter/material.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:provider/provider.dart';
import 'package:breathing_connection/models/inhale_exhale_type.dart';

import 'loading_page.dart';

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
  //current user
  User curUser;
  void deleteCustomTechnique() async{
    //track if technique was deleted
    bool wasDeleted = false;
    //remove from custom technique id list for user
    curUser.customTechniqueIDs.removeWhere((customTechniqueID) {
      return customTechniqueID == techniqueToDisplay.techniqueID;
    });
    //update custom technique id list for user in backend
    wasDeleted = await UserService(uid: curUser.userId).handleCustomTechnique(curUser.customTechniqueIDs);
    //only delete from technique list if previous request was successful
    if(wasDeleted){
      //update technique list in backend
      await TechniqueService().handleCustomTechnique('remove', techniqueToDisplay);
      //route back to root if technique was deleted
      Navigator.of(context).pushReplacementNamed("/root");
    }
  }
  void getTechniqueDependencies(){
    //get technique data
    techniqueToDisplay = Provider.of<ViewTechniqueDetailsHandler>(context).techniqueBeingViewed;
    //get inhale/exhale data from list in main data based on inhaleExhaleTypeID
    inhaleType = mainData.inhaleExhaleTypes.firstWhere((inhaleExhaleType) => inhaleExhaleType.inhaleExhaleTypeID == techniqueToDisplay.inhaleTypeID);
    exhaleType = mainData.inhaleExhaleTypes.firstWhere((inhaleExhaleType) => inhaleExhaleType.inhaleExhaleTypeID == techniqueToDisplay.exhaleTypeID);
  }
  void handleBeginTechniqueInEnvironment(){
    //set technique being viewed in handler provider
    Provider.of<ViewTechniqueDetailsHandler>(context, listen: false).setTechnique(techniqueToDisplay);
    //send to technique details page
    Navigator.of(context).pushNamed('/environment');
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //selected theme data
    appTheme = Provider.of<CurrentThemeHandler>(context).currentTheme;
    //current user data
    curUser = Provider.of<User>(context);
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: MainDataService().mainData,
        builder: (context, snapshot){
          if(snapshot.hasData){
            mainData = snapshot.data;
            getTechniqueDependencies();
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
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: appTheme.textSecondaryColor,
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
                            child: Wrap(
                                runAlignment: WrapAlignment.spaceBetween,
                                runSpacing: 5,
                                spacing: 5,
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
                                      '${techniqueToDisplay.inhaleDuration} second(s) ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: appTheme.textPrimaryColor
                                      )
                                  ),
                                  Text(
                                      '(${inhaleType.description})',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: appTheme.textPrimaryColor,
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
                            child: Wrap(
                                runAlignment: WrapAlignment.spaceBetween,
                                runSpacing: 5,
                                spacing: 5,
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
                            padding: EdgeInsets.only(top: 4, bottom: 4),
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
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 12),
                            child: Wrap(
                                runAlignment: WrapAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Minimum Session Duration: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: appTheme.textPrimaryColor
                                      )
                                  ),
                                  Text(
                                      'Sessions for this technique must be at least ${techniqueToDisplay.minSessionDurationInMinutes} minutes',
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
                    margin: EdgeInsets.only(top: 68, bottom: 24),
                    subtitleAlignment: TextAlign.justify,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 28, bottom: 60),
                    child: TextButton(
                      onPressed: () {
                        //begin technique in environment
                        handleBeginTechniqueInEnvironment();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        child: Text(
                          'Begin Technique',
                          style: TextStyle(
                              color: appTheme.textPrimaryColor,
                              fontSize: 24
                          ),
                        ),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: appTheme.brandPrimaryColor
                      ),
                    ),
                  ),
                  if(techniqueToDisplay.associatedUserID != null) Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 28, bottom: 0),
                        child: TextButton(
                          onPressed: () async{
                            //send to custom technique page with edit mode on
                            Navigator.of(context).pushNamed('/create-custom-technique', arguments: RouteArguments(isEditing: true, selectedTechnique: techniqueToDisplay));
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 36, vertical: 2),
                            child: Text(
                              'Edit Technique',
                              style: TextStyle(
                                  color: appTheme.textPrimaryColor,
                                  fontSize: 24
                              ),
                            ),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor: appTheme.brandPrimaryColor
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 28, bottom: 60),
                        child: TextButton(
                          onPressed: () async{
                            //prompt if user wants to permanently delete custom technique
                            await showDialog(
                                context: context,
                                builder: (context){
                                  return DialogPrompt(
                                    titlePadding: EdgeInsets.only(top: 12),
                                    subtitlePadding: EdgeInsets.only(top: 16, bottom: 28, left: 24, right: 24),
                                    approveButtonText: 'Delete',
                                    denyButtonText: 'Back to List',
                                    titleText: 'Confirm Deletion',
                                    subtitleText: 'Are you sure you want to delete this technique? It will be permanently removed from our services and you will not be able to access once you confirm.',
                                    headerIcon: Icons.delete_forever,
                                    headerBgColor: appTheme.errorColor,
                                    approveButtonColor: appTheme.errorColor,
                                    denyButtonColor: appTheme.brandPrimaryColor,
                                    titleColor: appTheme.textAccentColor,
                                    bgColor: appTheme.bgPrimaryColor,
                                    subtitleColor: appTheme.textAccentColor,
                                    cbFunction: () async{
                                      deleteCustomTechnique();
                                    },
                                  );
                                }
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                            child: Text(
                              'Permanently Delete',
                              style: TextStyle(
                                  color: appTheme.textPrimaryColor,
                                  fontSize: 24
                              ),
                            ),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor: appTheme.errorColor
                          ),
                        ),
                      ),
                    ],
                  )
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
}
