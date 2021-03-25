import 'dart:async';
import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/technique.dart';
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
                dialogHeight: screenHeight / 2.13,
                titlePadding: EdgeInsets.only(top: 12),
                subtitlePadding: EdgeInsets.only(top: 8, bottom: 20, left: 24, right: 24),
                headerIcon: Icons.add_moderator,
                headerBgColor: brandPrimary,
                approveButtonText: 'Purchase',
                approveButtonColor: brandPrimary,
                denyButtonText: 'Not Now',
                denyButtonColor: Colors.red,
                titleText: 'Show Your Love',
                subtitleText: 'Kindly consider purchasing a Pro License to contribute to our development efforts to help the world relax.',
                cbFunction: (){
                  //redirect to PRO page
                  Provider.of<CurrentPageHandler>(widget.rootContext, listen: false).setPageIndex(proLicensePage.pageIndex);
                },
              );
            });
        }
      );
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
        child: ListView.builder(
          itemCount: availableTechniques.length,
          itemBuilder: (context, index){
            return TechniqueCard(
                technique: availableTechniques[index]
            );
          },
        ),
      ),
      floatingActionButton: curUser.hasFullAccess ? Container(
        width: 70,
        height: 70,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: (){
              //send to create custom technique page
              Navigator.pushNamed(context, '/create-custom-technique');
            },
            child: Icon(
              Icons.add_to_photos,
              size: 32,
            ),
            backgroundColor: Colors.deepOrangeAccent[400],
            elevation: 6,
            tooltip: "Create a Custom Technique",
          ),
        ),
      ) : Container(),
    );
  }
}
