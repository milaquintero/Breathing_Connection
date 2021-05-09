import 'dart:async';
import 'package:breathing_connection/utility.dart';
import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/asset_handler.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/models/view_technique_details_handler.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:breathing_connection/widgets/dialog_alert.dart';
import 'package:breathing_connection/widgets/dialog_prompt.dart';
import 'package:breathing_connection/widgets/fancy_split_page.dart';
import 'package:breathing_connection/widgets/technique_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:breathing_connection/models/main_data.dart';

List<Technique> getTechniques(List<int> techniqueIDs, List<Technique> availableTechniques, String op, List<String> availableImages){
  List<Technique> techniqueMatches = [];
  for(int techniqueID in techniqueIDs){
    Technique techniqueMatch = availableTechniques
        .firstWhere(
            (technique) => technique.techniqueID == techniqueID,
            orElse: () => null
    );
    Technique mutableTechnique = Technique.clone(techniqueMatch);
    //only get default image if technique isn't custom
    if(op != 'custom' && techniqueMatch != null){
      mutableTechnique.assetImage = getAssetImage(op, availableImages);
    }
    techniqueMatches.add(mutableTechnique);
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
  return availableImages
      .firstWhere(
          (imageUrl) => imageUrl.contains(patternToMatch),
          orElse: () => ""
  );
}

class HomePage extends StatefulWidget {
  final BuildContext rootContext;
  HomePage({this.rootContext, Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  //timer for email subscription dialog
  Timer emailSubDialogTimer;
  //timer for email verification dialog
  Timer emailVerificationTimer;
  //main content
  List<Widget> mainContent = [];
  //screen height
  double screenHeight;
  //app theme data
  AppTheme appTheme;
  //app main data
  MainData mainData;
  //CDN asset handler
  AssetHandler assetHandler;
  //current user
  User curUser;
  //popup is queued flag
  bool popupIsQueued = false;
  //available techniques
  List<Technique> availableTechniques;
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    emailSubDialogTimer?.cancel();
    emailVerificationTimer?.cancel();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //selected theme data
    appTheme = Provider.of<CurrentThemeHandler>(widget.rootContext).currentTheme;
    //app main data
    mainData = Provider.of<MainData>(widget.rootContext);
    //get asset handler for CDN resources
    assetHandler = Provider.of<AssetHandler>(widget.rootContext);
    //screen height
    screenHeight = MediaQuery.of(context).size.height;
    //available techniques
    availableTechniques = Provider.of<List<Technique>>(context);
  }
  void handleQueueingPopups() async {
    //handle showing email confirmation dialog if user hasn't verified
    if(Utility.userJustRegistered && ModalRoute.of(context).isCurrent){
      emailVerificationTimer = Timer(Duration(seconds: 2), (){
        showDialog(
            context: context,
            builder: (context){
              return DialogAlert(
                titlePadding: EdgeInsets.only(top: 12),
                subtitlePadding: EdgeInsets.only(top: 16, bottom: 28, left: 24, right: 24),
                buttonText: 'Back to Home',
                cbFunction: (){
                  Utility.userJustRegistered = false;
                },
                titleText: 'Welcome',
                subtitleText: 'Please check your email to complete verifying your Breathing Connection account.',
                headerIcon: Icons.fact_check,
                headerBgColor: Colors.green[600],
                buttonColor: appTheme.brandPrimaryColor,
                titleTextColor: appTheme.textAccentColor,
                bgColor: appTheme.bgPrimaryColor,
                subtitleTextColor: appTheme.textAccentColor,
              );
            }
        );
      });
    }
    //handle showing email subscription dialog if user isn't signed up (only show if on home page)
    if(!Utility.userJustRegistered && !popupIsQueued && !curUser.isSubscribedToEmails && ModalRoute.of(context).isCurrent){
      popupIsQueued = true;
      emailSubDialogTimer = Timer(Duration(seconds: mainData.popupWaitTime), (){
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context){
              return DialogPrompt(
                bgColor: appTheme.bgPrimaryColor,
                titlePadding: EdgeInsets.only(top: 12),
                subtitlePadding: EdgeInsets.only(top: 12, bottom: 20, left: 28, right: 28),
                headerIcon: Icons.email,
                headerBgColor: appTheme.brandPrimaryColor,
                approveButtonText: mainData.emailPopupApproveBtnText,
                approveButtonColor: appTheme.brandPrimaryColor,
                denyButtonText: mainData.emailPopupDenyBtnText,
                denyButtonColor: appTheme.errorColor,
                titleText: mainData.emailPopupHeaderText,
                titleColor: appTheme.cardTitleColor,
                subtitleText: mainData.emailPopupBodyText,
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
            padding: EdgeInsets.only(top: 24, bottom: 32),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.blueGrey[400], Color.lerp(appTheme.bgPrimaryColor, Colors.blueGrey[400], 0.5), appTheme.bgPrimaryColor],
                center: Alignment(0.6, -0.3),
                focal: Alignment(0.3, -0.1),
                focalRadius: 3.5,
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  appTheme.themeID == 2 ? 'assets/logo_with_name-dark.png' : 'assets/logo_with_name.png',
                  height: screenHeight / 4.3,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    mainData.homePageTitleText,
                    style: TextStyle(
                        fontSize: 26,
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
        child: StreamBuilder(
          stream: UserService().userWithData,
          builder: (context, userSnapshot){
            if(userSnapshot.hasData){
              curUser = userSnapshot.data;
              handleQueueingPopups();
              return ListView(
                shrinkWrap: true,
                children: [
                  TechniqueSection(
                      headerText: mainData.amSessionHeaderText,
                      techniques: getTechniques([curUser.amTechniqueID], availableTechniques, 'day', mainData.images),
                      textBgColor: appTheme.amTechniqueSectionColor,
                      textColor: appTheme.amTechniqueTextColor,
                      startIcon: Icons.play_circle_fill,
                      headerColor: appTheme.amTechniqueSectionColor,
                      headerTextColor: appTheme.amTechniqueTextColor,
                      decorationColor: appTheme.bgAccentColor,
                      assetURL: assetHandler.imageAssetURL,
                      viewTechniqueDetails: (Technique selectedTechnique){
                        handleViewTechniqueDetails(selectedTechnique, widget.rootContext);
                      }
                  ),
                  TechniqueSection(
                    headerText: mainData.pmSessionHeaderText,
                    techniques: getTechniques([curUser.pmTechniqueID], availableTechniques, 'night', mainData.images),
                    textBgColor: appTheme.pmTechniqueSectionColor,
                    textColor: appTheme.pmTechniqueTextColor,
                    startIcon: Icons.play_circle_fill,
                    headerColor: appTheme.pmTechniqueSectionColor,
                    headerTextColor: appTheme.pmTechniqueTextColor,
                    decorationColor: appTheme.bgAccentColor,
                    assetURL: assetHandler.imageAssetURL,
                    viewTechniqueDetails: (Technique selectedTechnique){
                      handleViewTechniqueDetails(selectedTechnique, widget.rootContext);
                    },
                  ),
                  TechniqueSection(
                    headerText: mainData.emergencySessionHeaderText,
                    techniques: getTechniques([curUser.emergencyTechniqueID], availableTechniques, 'emergency', mainData.images),
                    textBgColor: appTheme.emergencyTechniqueSectionColor,
                    textColor: appTheme.emergencyTechniqueTextColor,
                    startIcon: Icons.add_circle,
                    headerColor: appTheme.emergencyTechniqueSectionColor,
                    headerTextColor: appTheme.emergencyTechniqueTextColor,
                    decorationColor: appTheme.bgAccentColor,
                    assetURL: assetHandler.imageAssetURL,
                    viewTechniqueDetails: (Technique selectedTechnique){
                      handleViewTechniqueDetails(selectedTechnique, widget.rootContext);
                    },
                  ),
                  if (curUser.hasFullAccess) TechniqueSection(
                    headerText: mainData.challengeSessionHeaderText,
                    techniques: getTechniques([curUser.challengeTechniqueID], availableTechniques, 'challenge', mainData.images),
                    textBgColor: appTheme.challengeTechniqueSectionColor,
                    textColor: appTheme.challengeTechniqueTextColor,
                    startIcon: Icons.play_circle_fill,
                    headerColor: appTheme.challengeTechniqueSectionColor,
                    headerTextColor: appTheme.challengeTechniqueTextColor,
                    decorationColor: appTheme.bgAccentColor,
                    assetURL: assetHandler.imageAssetURL,
                    viewTechniqueDetails: (Technique selectedTechnique){
                      handleViewTechniqueDetails(selectedTechnique, widget.rootContext);
                    },
                  ),
                  if (curUser.hasFullAccess && curUser.customTechniqueIDs.isNotEmpty) TechniqueSection(
                    headerText: mainData.customSessionHeaderText,
                    techniques: getTechniques(curUser.customTechniqueIDs, availableTechniques, 'custom', mainData.images),
                    textBgColor: appTheme.customTechniqueSectionColor,
                    textColor: appTheme.customTechniqueTextColor,
                    startIcon: Icons.play_circle_fill,
                    headerColor: appTheme.customTechniqueSectionColor,
                    headerTextColor: appTheme.customTechniqueTextColor,
                    decorationColor: appTheme.bgAccentColor,
                    assetURL: assetHandler.imageAssetURL,
                    viewTechniqueDetails: (Technique selectedTechnique){
                      handleViewTechniqueDetails(selectedTechnique, widget.rootContext);
                    },
                  )
                ],
              );
            }
            else{
              return Container(
                color: Colors.blueGrey[400],
                child: Center(
                  child: SpinKitDualRing(
                    color: appTheme.textPrimaryColor,
                    size: 32,
                  ),
                ),
              );
            }
          }
        ),
      ),
      withFloatingActionButton: true,
      floatingActionButton: Container(
        width: 80,
        height: 80,
        margin: EdgeInsets.only(top: 19),
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.transparent,
                width: 1
            ),
            borderRadius: BorderRadius.circular(19),
        ),
        child: FloatingActionButton(
          onPressed: () {
            showBottomSheet(
                elevation: 60,
                context: context,
                builder: (context){
                  return Container(
                    height: 330,
                    decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [appTheme.bgPrimaryColor, Color.lerp(appTheme.brandPrimaryColor, appTheme.bgPrimaryColor, 0.5), appTheme.brandPrimaryColor],
                          center: Alignment(0.6, -0.3),
                          focal: Alignment(0.3, -0.1),
                          focalRadius: 3.5,
                        ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 32, left: 36, right: 36),
                            child: Column(
                              children: [
                                Text(
                                    'Your Information',
                                    style: TextStyle(
                                      color: appTheme.textPrimaryColor,
                                      fontSize: 30
                                    ),
                                ),
                                Divider(
                                  color: appTheme.textPrimaryColor,
                                ),
                                SizedBox(height: 4,),
                                Text(
                                  'Username',
                                  style: TextStyle(
                                      color: appTheme.textPrimaryColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(height: 2,),
                                Text(
                                  curUser.username,
                                  style: TextStyle(
                                    color: appTheme.disabledCardTextColor,
                                    fontSize: 24,
                                  ),
                                ),
                                SizedBox(height: 16,),
                                Text(
                                  'Email',
                                  style: TextStyle(
                                      color: appTheme.textPrimaryColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(height: 2,),
                                Text(
                                  curUser.email,
                                  style: TextStyle(
                                    color: appTheme.disabledCardTextColor,
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 24),
                            child: TextButton(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                child: Text(
                                    'Back to Home',
                                    style: TextStyle(
                                        color: appTheme.textPrimaryColor,
                                        fontSize: 24
                                    ),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.deepOrange[600]
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                  Icons.person,
                  size: 29,
              ),
              Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 12
                  ),
              )
            ],
          ),
          elevation: 7,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: Colors.deepOrange[600],
          foregroundColor: appTheme.textPrimaryColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
