import 'dart:async';
import 'package:breathing_connection/main.dart';
import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/models/view_technique_details_handler.dart';
import 'package:breathing_connection/styles.dart';
import 'package:breathing_connection/widgets/dialog_prompt.dart';
import 'package:breathing_connection/widgets/technique_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/models/nav_link.dart';
class TechniqueListPage extends StatefulWidget {
  final BuildContext rootContext;
  TechniqueListPage({this.rootContext});
  @override
  _TechniqueListPageState createState() => _TechniqueListPageState();
}

class _TechniqueListPageState extends State<TechniqueListPage> {
  //timer for PRO dialog
  Timer proDialogTimer;
  @override
  void dispose() {
    super.dispose();
    proDialogTimer?.cancel();
  }
  @override
  Widget build(BuildContext context) {
    //available techniques
    List<Technique> availableTechniques = Provider.of<List<Technique>>(context);
    //current user data
    User curUser = Provider.of<User>(context);
    //screen height
    double screenHeight = MediaQuery.of(context).size.height;
    //main content for list view
    List<Widget> mainContent = [];
    //always show technique list in main content (with conditional rendering for PRO techniques)
    availableTechniques.forEach((technique){
      mainContent.add(TechniqueCard(
        technique: technique,
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
      proDialogTimer = Timer(Duration(seconds: 5), (){
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context){
              return DialogPrompt(
                dialogHeight: screenHeight / 2.25,
                titlePadding: EdgeInsets.only(top: 12),
                subtitlePadding: EdgeInsets.only(top: 12, bottom: 20, left: 22, right: 22),
                headerIcon: Icons.add_moderator,
                headerBgColor: brandPrimary,
                approveButtonText: 'Try It Now',
                approveButtonColor: brandPrimary,
                denyButtonText: 'Close',
                denyButtonColor: Colors.red,
                titleText: 'Breathe Easy',
                subtitleText: 'Enjoy immersive healing through breath-work and meditation with Breathing Connection Pro!',
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
          contentPadding: EdgeInsets.all(20),
          onTap: (){
            //top card should take user to custom technique form
            Navigator.of(context).pushNamed('/create-custom-technique');
          },
          tileColor: Colors.cyan[800],
          title: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                  left: -80,
                  top: -100,
                  child: Container(
                    height: 400,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(300),
                      color: Colors.blueGrey[400],
                    ),
                  )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add Technique',
                    style: TextStyle(
                      fontSize: screenHeight / 23,
                      color: Colors.white
                    ),
                  ),
                  SizedBox(width: 10,),
                  Icon(
                    Icons.add_circle,
                    size: screenHeight / 19,
                    color: Colors.white,
                  )
                ],
              )
            ]
          ),
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: brandPrimary,
        toolbarHeight: appBarHeight,
        title: Text(
            'Breathing Techniques',
            style: appBarTextStyle,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: wellSectionBg,
        child: ListView(
          children: mainContent,
        ),
      ),
    );
  }
}
