import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/styles.dart';
import 'package:breathing_connection/widgets/pro_license_dialog.dart';
import 'package:breathing_connection/widgets/technique_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:breathing_connection/models/user.dart';
class TechniqueList extends StatefulWidget {
  @override
  _TechniqueListState createState() => _TechniqueListState();
}

class _TechniqueListState extends State<TechniqueList> {
  @override
  Widget build(BuildContext context) {
    List<Technique> availableTechniques = Provider.of<List<Technique>>(context);
    User curUser = Provider.of<User>(context);
    //handle showing purchase pro license dialog if user doesn't have full version of app
    if(!curUser.hasFullAccess){
      Future.delayed(Duration(seconds: 5), () => showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context){
            return ProLicenseDialog();
          })
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
