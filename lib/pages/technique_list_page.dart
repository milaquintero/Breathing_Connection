import 'dart:async';
import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/models/view_technique_details_handler.dart';
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
  //main content for list view
  List<Widget> mainContent = [];
  //selected theme data
  AppTheme appTheme;
  //available techniques
  List<Technique> availableTechniques;
  //app main data
  MainData mainData;
  //current user data
  User curUser;
  @override
  void dispose() {
    super.dispose();
    proDialogTimer?.cancel();
  }
  @override
  void didChangeDependencies() {
    //selected theme data
    appTheme = Provider.of<CurrentThemeHandler>(widget.rootContext).currentTheme;
    //available techniques
    availableTechniques = List.from(Provider.of<List<Technique>>(context));
    //app main data
    mainData = Provider.of<MainData>(widget.rootContext);
    //current user data
    curUser = Provider.of<User>(context);
    //screen height
    double screenHeight = MediaQuery.of(context).size.height;
    //make sure no non associated custom techniques are displayed (UI validation)
    availableTechniques.removeWhere((technique) => technique.associatedUserID != null && technique.associatedUserID != curUser.userId);
    //always show technique list in main content (with conditional rendering for PRO techniques)
    availableTechniques.forEach((technique){
      mainContent.add(TechniqueCard(
          technique: technique,
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
            Provider.of<User>(widget.rootContext, listen: false).handleChangeTechnique(op, mutableTechnique.techniqueID, assetImages);
          },
          viewTechniqueDetails: (Technique selectedTechnique){
            //set technique being viewed in handler provider
            Provider.of<ViewTechniqueDetailsHandler>(widget.rootContext, listen: false).setTechnique(selectedTechnique);
            //send to technique details page
            Navigator.of(context).pushNamed('/technique-details');
          }
      ));
    });
    //handle showing purchase pro license dialog if user doesn't have full version of app
    if(!curUser.hasFullAccess){
      //page links from main data provider
      List<NavLink> navLinks = Provider.of<MainData>(widget.rootContext).pages;
      //find pro page in main data page links
      NavLink proLicensePage = navLinks.firstWhere((page) => page.pageRoute == '/pro');
      //screen height
      double screenHeight = MediaQuery.of(context).size.height;
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
    //user has full access add custom technique button
    else{
      mainContent.insert(0, Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          onTap: (){
            //top card should take user to custom technique form
            Navigator.of(context).pushNamed('/create-custom-technique');
          },
          tileColor: appTheme.brandSecondaryColor,
          title: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                    left: -80,
                    top: -100,
                    child: Container(
                      height: 450,
                      width: 450,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(300),
                        color: appTheme.bgAccentColor,
                        gradient: RadialGradient(
                          colors: [Colors.blueGrey[400], Color.lerp(appTheme.bgAccentColor, Colors.blueGrey[400], 0.01), appTheme.bgAccentColor],
                          center: Alignment(0.6, 0.3),
                          focal: Alignment(0.3, -0.1),
                          focalRadius: 0.5,
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
      ));
    }
    super.didChangeDependencies();
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
        child: ListView(
          children: mainContent,
        ),
      ),
    );
  }
}
