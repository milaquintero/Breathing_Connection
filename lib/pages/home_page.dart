import 'dart:async';
import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/models/view_technique_details_handler.dart';
import 'package:breathing_connection/widgets/dialog_prompt.dart';
import 'package:breathing_connection/widgets/fancy_split_page.dart';
import 'package:breathing_connection/widgets/technique_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:breathing_connection/models/main_data.dart';

List<Technique> getTechniques(List<int> techniqueIDs, List<Technique> availableTechniques, String op, List<String> availableImages){
  List<Technique> techniqueMatches = [];
  for(int techniqueID in techniqueIDs){
    Technique techniqueMatch = availableTechniques.firstWhere((technique) => technique.techniqueID == techniqueID);
    //only get default image if technique isn't custom
    if(op != 'custom'){
      techniqueMatch.assetImage = getAssetImage(op, availableImages);
    }
    techniqueMatches.add(techniqueMatch);
  }
  return techniqueMatches;
}

void handleViewTechniqueDetails(Technique selectedTechnique, BuildContext rootContext){
    //set technique being viewed in handler provider
    Provider.of<ViewTechniqueDetailsHandler>(rootContext, listen: false).setTechnique(selectedTechnique);
    //send to technique details page
    Navigator.of(rootContext).pushNamed('/technique-details');
}

String getAssetImage(String patternToMatch, List<String> availableImages){
  return availableImages.firstWhere((imageUrl)=>imageUrl.contains(patternToMatch));
}

class HomePage extends StatefulWidget {
  final BuildContext rootContext;
  HomePage({this.rootContext});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //timer for email subscription dialog
  Timer emailSubDialogTimer;
  //main content
  List<Widget> mainContent = [];
  //screen height
  double screenHeight;
  //app theme data
  AppTheme appTheme;
  //app main data
  MainData mainData;
  //list of available techniques
  List<Technique> availableTechniques;
  //current user data
  User curUser;
  @override
  void dispose() {
    super.dispose();
    emailSubDialogTimer?.cancel();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //selected theme data
    appTheme = Provider.of<CurrentThemeHandler>(widget.rootContext).currentTheme;
    //current user data
    curUser = Provider.of<User>(widget.rootContext);
    //list of available techniques
    availableTechniques = Provider.of<List<Technique>>(widget.rootContext);
    //app main data
    mainData = Provider.of<MainData>(widget.rootContext);
    //screen height
    screenHeight = MediaQuery.of(context).size.height;
    //add morning section to main content
    mainContent.add(
        TechniqueSection(
            headerText: 'Day Session',
            techniques: getTechniques([curUser.amTechniqueID], availableTechniques, 'day', mainData.images),
            textBgColor: appTheme.amTechniqueSectionColor,
            textColor: appTheme.amTechniqueTextColor,
            startIcon: Icons.play_circle_fill,
            headerColor: appTheme.amTechniqueSectionColor,
            headerTextColor: appTheme.amTechniqueTextColor,
            decorationColor: appTheme.bgAccentColor,
            viewTechniqueDetails: (Technique selectedTechnique){
              handleViewTechniqueDetails(selectedTechnique, widget.rootContext);
            }
        )
    );
    //add night section to main content
    mainContent.add(
        TechniqueSection(
          headerText: 'Night Session',
          techniques: getTechniques([curUser.pmTechniqueID], availableTechniques, 'night', mainData.images),
          textBgColor: appTheme.pmTechniqueSectionColor,
          textColor: appTheme.pmTechniqueTextColor,
          startIcon: Icons.play_circle_fill,
          headerColor: appTheme.pmTechniqueSectionColor,
          headerTextColor: appTheme.pmTechniqueTextColor,
          decorationColor: appTheme.bgAccentColor,
          viewTechniqueDetails: (Technique selectedTechnique){
            handleViewTechniqueDetails(selectedTechnique, widget.rootContext);
          },
        )
    );
    //add emergency section to main content
    mainContent.add(
        TechniqueSection(
          headerText: 'Emergency',
          techniques: getTechniques([curUser.emergencyTechniqueID], availableTechniques, 'emergency', mainData.images),
          textBgColor: appTheme.emergencyTechniqueSectionColor,
          textColor: appTheme.emergencyTechniqueTextColor,
          startIcon: Icons.add_circle,
          headerColor: appTheme.emergencyTechniqueSectionColor,
          headerTextColor: appTheme.emergencyTechniqueTextColor,
          decorationColor: appTheme.bgAccentColor,
          viewTechniqueDetails: (Technique selectedTechnique){
            handleViewTechniqueDetails(selectedTechnique, widget.rootContext);
          },
        )
    );
    //check if user has paid version
    if(curUser.hasFullAccess){
      //add challenge section
      mainContent.add(
          TechniqueSection(
            headerText: 'Challenge',
            techniques: getTechniques([curUser.challengeTechniqueID], availableTechniques, 'challenge', mainData.images),
            textBgColor: appTheme.challengeTechniqueSectionColor,
            textColor: appTheme.challengeTechniqueTextColor,
            startIcon: Icons.play_circle_fill,
            headerColor: appTheme.challengeTechniqueSectionColor,
            headerTextColor: appTheme.challengeTechniqueTextColor,
            decorationColor: appTheme.bgAccentColor,
            viewTechniqueDetails: (Technique selectedTechnique){
              handleViewTechniqueDetails(selectedTechnique, widget.rootContext);
            },
          )
      );
      if(curUser.customTechniqueIDs.isNotEmpty){
        //add formatted custom techniques
        mainContent.add(
            TechniqueSection(
              headerText: 'Custom Session',
              techniques: getTechniques(curUser.customTechniqueIDs, availableTechniques, 'custom', mainData.images),
              textBgColor: appTheme.customTechniqueSectionColor,
              textColor: appTheme.customTechniqueTextColor,
              startIcon: Icons.play_circle_fill,
              headerColor: appTheme.customTechniqueSectionColor,
              headerTextColor: appTheme.customTechniqueTextColor,
              decorationColor: appTheme.bgAccentColor,
              viewTechniqueDetails: (Technique selectedTechnique){
                handleViewTechniqueDetails(selectedTechnique, widget.rootContext);
              },
            )
        );
      }
    }
    //handle showing email subscription dialog if user isn't signed up (only show if on home page)
    if(!curUser.isSubscribedToEmails && ModalRoute.of(context).isCurrent){
      //screen height
      double screenHeight = MediaQuery.of(context).size.height;
      emailSubDialogTimer = Timer(Duration(seconds: mainData.popupWaitTime), (){
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context){
              return DialogPrompt(
                dialogHeight: screenHeight / 2.05,
                bgColor: appTheme.bgPrimaryColor,
                titlePadding: EdgeInsets.only(top: 12),
                subtitlePadding: EdgeInsets.only(top: 12, bottom: 20, left: 28, right: 28),
                headerIcon: Icons.email,
                headerBgColor: appTheme.brandPrimaryColor,
                approveButtonText: 'Subscribe',
                approveButtonColor: appTheme.brandPrimaryColor,
                denyButtonText: 'Close',
                denyButtonColor: appTheme.errorColor,
                titleText: 'Stay In Touch',
                titleColor: appTheme.cardTitleColor,
                subtitleText: 'Subscribe to our newsletter to get weekly video trainings, breath-work hacks, meditation tips and much more!',
                subtitleColor: appTheme.cardSubtitleColor,
                cbFunction: (){
                  //redirect to email subscription page
                  Navigator.pushNamed(context, '/email-subscription');
                },
              );
            });
        }
      );
    }
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
            padding: EdgeInsets.only(top: 44, bottom: 12),
            decoration: BoxDecoration(
              color: appTheme.bgPrimaryColor,
            ),
            height: screenHeight / 2.40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/logo_with_name.jpg',
                  height: screenHeight / 4.3,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Text(
                    'Your breathing Journey',
                    style: TextStyle(
                        fontSize: 24,
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
      mainContentColor: appTheme.brandPrimaryColor,
      //remove padding automatically added by ListView
      mainContent: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: mainContent,
        ),
      )
    );
  }
}
