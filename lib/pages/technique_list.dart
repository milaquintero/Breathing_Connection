import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/services/technique_service.dart';
import 'package:breathing_connection/styles.dart';
import 'package:flutter/material.dart';
class TechniqueList extends StatefulWidget {
  @override
  _TechniqueListState createState() => _TechniqueListState();
}

class _TechniqueListState extends State<TechniqueList> {
  @override
  Widget build(BuildContext context) {
    List<Technique> availableTechniques = TechniqueService.techniques;
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
      body: ListView.builder(
      itemCount: availableTechniques.length,
      itemBuilder: (context, index){
        return ListTile(
          title: Text(availableTechniques[index].title),
          subtitle: Text(availableTechniques[index].description),
          onTap: (){},
        );
      },
    ),
    );
  }
}
