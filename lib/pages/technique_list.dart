import 'dart:async';

import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/styles.dart';
import 'package:breathing_connection/widgets/pro_license_dialog.dart';
import 'package:breathing_connection/widgets/technique_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:breathing_connection/models/user.dart';
class TechniqueList extends StatefulWidget {
  final BuildContext rootContext;
  TechniqueList({this.rootContext});
  @override
  _TechniqueListState createState() => _TechniqueListState();
}

class _TechniqueListState extends State<TechniqueList> {
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
      proDialogTimer = Timer(Duration(seconds: 5), (){
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context){
              return ProLicenseDialog(rootContext: context);
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
    );
  }
}
