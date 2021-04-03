import 'dart:async';
import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/models/view_technique_details_handler.dart';
import 'package:breathing_connection/widgets/dialog_prompt.dart';
import 'package:breathing_connection/widgets/fancy_page.dart';
import 'package:breathing_connection/widgets/technique_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:breathing_connection/models/main_data.dart';

import '../styles.dart';

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
  //image header for side nav
  String sideNavHeaderImg = 'assets/logo_with_name.jpg';
  //timer for email subscription dialog
  Timer emailSubDialogTimer;
  @override
  void dispose() {
    super.dispose();
    emailSubDialogTimer?.cancel();
  }
  @override
  Widget build(BuildContext context) {
    User curUser = Provider.of<User>(widget.rootContext);
    List<Technique> availableTechniques = Provider.of<List<Technique>>(widget.rootContext);
    MainData mainData = Provider.of<MainData>(widget.rootContext);
    //main content to display in ListView
    List<Widget> mainContent = [
      TechniqueSection(
        headerText: 'Day Session',
        techniques: getTechniques([curUser.amTechniqueID], availableTechniques, 'day', mainData.images),
        textBgColor: Colors.lightBlue[900],
        textColor: Colors.white,
        startIcon: Icons.play_circle_fill,
        headerColor: Colors.lightBlue[900],
        headerTextColor: Colors.white,
        viewTechniqueDetails: (Technique selectedTechnique){
          handleViewTechniqueDetails(selectedTechnique, widget.rootContext);
        },
      ),
      TechniqueSection(
        headerText: 'Night Session',
        techniques: getTechniques([curUser.pmTechniqueID], availableTechniques, 'night', mainData.images),
        textBgColor: Colors.pinkAccent[700],
        textColor: Colors.white,
        startIcon: Icons.play_circle_fill,
        headerColor: Colors.pinkAccent[700],
        headerTextColor: Colors.white,
        viewTechniqueDetails: (Technique selectedTechnique){
          handleViewTechniqueDetails(selectedTechnique, widget.rootContext);
        },
      ),
      TechniqueSection(
        headerText: 'Emergency',
        techniques: getTechniques([curUser.emergencyTechniqueID], availableTechniques, 'emergency', mainData.images),
        textBgColor: Colors.red[700],
        textColor: Colors.white,
        startIcon: Icons.add_circle,
        headerColor: Colors.red[700],
        headerTextColor: Colors.white,
        viewTechniqueDetails: (Technique selectedTechnique){
          handleViewTechniqueDetails(selectedTechnique, widget.rootContext);
        },
      )
    ];
    //check if user has paid version
    if(curUser.hasFullAccess){
      //add challenge section
      mainContent.add(
        TechniqueSection(
          headerText: 'Challenge',
          techniques: getTechniques([curUser.challengeTechniqueID], availableTechniques, 'challenge', mainData.images),
          textBgColor: Colors.cyan[800],
          textColor: Colors.white,
          startIcon: Icons.play_circle_fill,
          headerColor: Colors.cyan[800],
          headerTextColor: Colors.white,
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
              textBgColor: Colors.deepOrangeAccent[400],
              textColor: Colors.white,
              startIcon: Icons.play_circle_fill,
              headerColor: Colors.deepOrangeAccent[400],
              headerTextColor: Colors.white,
              viewTechniqueDetails: (Technique selectedTechnique){
                handleViewTechniqueDetails(selectedTechnique, widget.rootContext);
              },
            )
        );
      }
    }
    //screen height
    double screenHeight = MediaQuery.of(context).size.height;
    //handle showing email subscription dialog if user isn't signed up (only show if on home page)
    if(!curUser.isSubscribedToEmails && ModalRoute.of(context).isCurrent){
      //screen height
      double screenHeight = MediaQuery.of(context).size.height;
      emailSubDialogTimer = Timer(Duration(seconds: 5), (){
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context){
              return DialogPrompt(
                dialogHeight: screenHeight / 2.05,
                titlePadding: EdgeInsets.only(top: 12),
                subtitlePadding: EdgeInsets.only(top: 12, bottom: 20, left: 28, right: 28),
                headerIcon: Icons.email,
                headerBgColor: brandPrimary,
                approveButtonText: 'Subscribe',
                approveButtonColor: brandPrimary,
                denyButtonText: 'Close',
                denyButtonColor: Colors.red,
                titleText: 'Stay In Touch',
                subtitleText: 'Subscribe to our newsletter to get weekly video trainings, breath-work hacks, meditation tips and much more!',
                cbFunction: (){
                  //redirect to email subscription page
                  Navigator.pushNamed(context, '/email-subscription');
                },
              );
            });
      }
      );
    }
    return FancyPage(
      headerColor: Colors.white,
      headerContent: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(top: 44, bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
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
                        color: Colors.black
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
      mainContentColor: brandPrimary,
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
