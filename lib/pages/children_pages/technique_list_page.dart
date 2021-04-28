import 'dart:async';
import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/models/view_technique_details_handler.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:breathing_connection/widgets/dialog_prompt.dart';
import 'package:breathing_connection/widgets/technique_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    mainData = Provider.of<MainData>(widget.rootContext);
    //selected theme data
    appTheme = Provider.of<CurrentThemeHandler>(widget.rootContext).currentTheme;
    //available techniques
    availableTechniques = Provider.of<List<Technique>>(context);
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
              return ListView.builder(
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
                          changeTechnique: (String op, Technique selectedTechnique){
                            //new technique object needed to avoid original technique obj from being mutated
                            Technique mutableTechnique = Technique.clone(selectedTechnique);
                            //get list of asset images for technique change method to determine appropriate image selection
                            List<String> assetImages = Provider.of<MainData>(widget.rootContext, listen: false).images;
                            //change technique for user
                            //Provider.of<User>(widget.rootContext, listen: false).handleChangeTechnique(op, mutableTechnique.techniqueID, assetImages);
                          },
                          viewTechniqueDetails: (Technique selectedTechnique){
                            //set technique being viewed in handler provider
                            Provider.of<ViewTechniqueDetailsHandler>(widget.rootContext, listen: false).setTechnique(selectedTechnique);
                            //send to technique details page
                            Navigator.of(context).pushNamed('/technique-details');
                          }
                      );
                    }
                    else {
                      return Container();
                    }
                  }
              );
            }
            else{
              return SpinKitDualRing(
                  color: appTheme.textPrimaryColor,
                  size: 32,
              );
            }
          },
        )
      ),
    );
  }
}
