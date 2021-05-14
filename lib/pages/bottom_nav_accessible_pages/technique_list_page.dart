import 'dart:async';
import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/route_arguments.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/models/view_technique_details_handler.dart';
import 'package:breathing_connection/pages/top_level_pages/loading_page.dart';
import 'package:breathing_connection/services/technique_service.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:breathing_connection/widgets/dialog_alert.dart';
import 'package:breathing_connection/widgets/dialog_prompt.dart';
import 'package:breathing_connection/widgets/technique_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/models/nav_link.dart';
import 'package:breathing_connection/models/app_theme.dart';
class TechniqueListPage extends StatefulWidget {
  final BuildContext rootContext;
  TechniqueListPage({this.rootContext});
  @override
  _TechniqueListPageState createState() => _TechniqueListPageState();
}

class _TechniqueListPageState extends State<TechniqueListPage> {
  //timer for PRO dialog
  Timer proDialogTimer;
  //selected theme data
  AppTheme appTheme;
  //app main data
  MainData mainData;
  //available techniques
  List<Technique> availableTechniques;
  //current user
  User curUser;
  //popup is queued flag
  bool popupIsQueued = false;
  @override
  void dispose() {
    super.dispose();
    proDialogTimer?.cancel();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //app main data
    mainData = Provider.of<MainData>(context);
    //selected theme data
    appTheme = Provider.of<CurrentThemeHandler>(widget.rootContext).currentTheme;
    //available techniques
    availableTechniques = Provider.of<List<Technique>>(context);
    //sort available techniques by id
    availableTechniques.sort((a,b){
      return a.techniqueID.compareTo(b.techniqueID);
    });
  }
  void handleQueueingPopup(){
    if(!curUser.hasFullAccess && !popupIsQueued && ModalRoute.of(context).isCurrent){
      //update popup queued flag
      popupIsQueued = true;
      //page links from main data provider
      List<NavLink> navLinks = Provider.of<MainData>(widget.rootContext).pages;
      //find pro page in main data page links
      NavLink proLicensePage = navLinks.firstWhere((page) => page.pageRoute == '/pro');
      proDialogTimer = Timer(Duration(seconds: mainData.popupWaitTime), (){
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context){
              return DialogPrompt(
                bgColor: appTheme.bgPrimaryColor,
                titlePadding: EdgeInsets.only(top: 12),
                subtitlePadding: EdgeInsets.only(top: 12, bottom: 20, left: 22, right: 22),
                headerIcon: Icons.add_moderator,
                headerBgColor: appTheme.brandPrimaryColor,
                approveButtonText: mainData.proPopupApproveBtnText,
                approveButtonColor: appTheme.brandPrimaryColor,
                denyButtonText: mainData.proPopupDenyBtnText,
                denyButtonColor: appTheme.errorColor,
                titleText: mainData.proPopupHeaderText,
                titleColor: appTheme.cardTitleColor,
                subtitleText: mainData.proPopupBodyText,
                subtitleColor: appTheme.cardSubtitleColor,
                cbFunction: (){
                  //redirect to PRO page
                  Provider.of<CurrentPageHandler>(widget.rootContext, listen: false).setPageIndex(proLicensePage.pageIndex);
                },
              );
            });
      }
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.brandPrimaryColor,
        toolbarHeight: mainData.appBarHeight,
        title: Text(
            'Breathing Techniques',
            style: TextStyle(
                fontSize: 30,
                letterSpacing: -0.25
            ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: appTheme.bgPrimaryColor,
        child: StreamBuilder(
          stream: UserService().userWithData,
          builder: (context, userSnapshot){
            if(userSnapshot.hasData){
              curUser = userSnapshot.data;
              handleQueueingPopup();
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: availableTechniques.length,
                          itemBuilder: (context, index){
                            //make sure no non associated custom techniques are displayed (UI validation)
                            if(availableTechniques[index].associatedUserID == null
                                || availableTechniques[index].associatedUserID == curUser.userId){
                              return TechniqueCard(
                                  userHasFullAccess: curUser.hasFullAccess,
                                  technique: availableTechniques[index],
                                  cardBgColor: appTheme.cardBgColor,
                                  cardBorderColor: appTheme.cardBorderColor,
                                  cardSubtitleColor: appTheme.cardSubtitleColor,
                                  cardTitleColor: appTheme.cardTitleColor,
                                  cardActionColor: appTheme.cardActionColor,
                                  disabledCardBgAccentColor: appTheme.disabledCardBgAccentColor,
                                  disabledCardBgColor: appTheme.disabledCardBgColor,
                                  disabledCardBorderColor: appTheme.disabledCardBorderColor,
                                  disabledCardTextColor: appTheme.disabledCardTextColor,
                                  changePersonalTechnique: (String op, Technique selectedTechnique) async{
                                    //change technique for user
                                    bool changeSuccessful = await UserService(uid: curUser.userId).handleChangeTechnique(op, selectedTechnique.techniqueID);
                                    //show success alert
                                    showDialog(
                                        context: context,
                                        builder: (context){
                                          return DialogAlert(
                                            titlePadding: EdgeInsets.only(top: 12),
                                            subtitlePadding: EdgeInsets.only(top: 16, bottom: 28, left: 24, right: 24),
                                            buttonText: 'Back to List',
                                            cbFunction: (){},
                                            titleText: changeSuccessful ? 'Success' : 'Error',
                                            subtitleText: changeSuccessful ? 'Changes to your personal techniques have been set in your account' : 'Unable to update the technique at this time. Please try again in a few moments',
                                            headerIcon: changeSuccessful ? Icons.fact_check : Icons.cancel,
                                            headerBgColor: changeSuccessful ? Colors.green[600] : appTheme.errorColor,
                                            buttonColor: appTheme.brandPrimaryColor,
                                            titleTextColor: appTheme.textAccentColor,
                                            bgColor: appTheme.bgPrimaryColor,
                                            subtitleTextColor: appTheme.textAccentColor,
                                          );
                                        }
                                    );
                                  },
                                  deleteCustomTechnique: (Technique selectedTechnique) async{
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
                                              //remove from custom technique id list for user
                                              curUser.customTechniqueIDs.removeWhere((customTechniqueID) {
                                                return customTechniqueID == selectedTechnique.techniqueID;
                                              });
                                              //update custom technique id list for user in backend
                                              bool changeSuccessful = await UserService(uid: curUser.userId).handleCustomTechnique(curUser.customTechniqueIDs);
                                              //remove from technique list in view
                                              availableTechniques.removeWhere((availableTechnique){
                                                return availableTechnique.techniqueID == selectedTechnique.techniqueID;
                                              });
                                              //only delete from technique list if previous request was successful
                                              if(changeSuccessful){
                                                //update technique list in backend
                                                await TechniqueService(uid: curUser.userId).handleCustomTechnique('remove', selectedTechnique);
                                              }
                                            },
                                          );
                                        }
                                    );
                                  },
                                  viewTechniqueDetails: (Technique selectedTechnique){
                                    //set technique being viewed in handler provider
                                    Provider.of<ViewTechniqueDetailsHandler>(widget.rootContext, listen: false).setTechnique(selectedTechnique);
                                    //send to technique details page
                                    Navigator.of(context).pushNamed('/technique-details');
                                  },
                                  editCustomTechnique: availableTechniques[index].associatedUserID != null ? (Technique selectedTechnique){
                                    //send to custom technique page with edit mode on
                                    Navigator.of(context).pushNamed('/create-custom-technique', arguments: RouteArguments(isEditing: true, selectedTechnique: selectedTechnique));
                                  } : (Technique selectedTechnique){}
                              );
                            }
                            else {
                              return Container();
                            }
                          }
                      ),
                    ),
                  ),
                  curUser.hasFullAccess ? Container(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [Colors.blueGrey[400], Color.lerp(appTheme.bgAccentColor, Colors.blueGrey[400], 0.01), appTheme.bgAccentColor],
                          center: Alignment(-10.5, 0.8),
                          focal: Alignment(0.3, -0.1),
                          focalRadius: 500.5,
                        )
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      onTap: (){
                        //top card should take user to custom technique form
                        Navigator.of(context).pushNamed('/create-custom-technique');
                      },
                      title: Stack(
                          alignment: Alignment.topCenter,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                                left: -100,
                                top: -120,
                                child: Container(
                                  height: 450,
                                  width: 450,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(300),
                                    color: appTheme.brandSecondaryColor,
                                    gradient: RadialGradient(
                                      colors: [appTheme.brandSecondaryColor, Color.lerp(appTheme.brandSecondaryColor, Colors.white, 0.1), appTheme.brandSecondaryColor],
                                      center: Alignment(0.6, 0.3),
                                      focal: Alignment(0.3, -0.1),
                                      focalRadius: 0.8,
                                    ),
                                  ),
                                )
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Add Technique',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: appTheme.textPrimaryColor,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Icon(
                                  Icons.add_circle,
                                  size: 32,
                                  color: appTheme.textPrimaryColor,
                                )
                              ],
                            )
                          ]
                      ),
                    ),
                  ) : Container(),
                ],
              );
            }
            else{
              return LoadingPage();
            }
          },
        )
      ),
    );
  }
}
