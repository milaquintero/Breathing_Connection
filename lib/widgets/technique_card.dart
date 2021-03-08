import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../styles.dart';
class TechniqueCard extends StatelessWidget {
  final Technique technique;
  TechniqueCard({this.technique});
  @override
  Widget build(BuildContext context) {
    User curUser = Provider.of<User>(context);
    EdgeInsets techniqueCardContentPadding = EdgeInsets.all(16);
    return Container(
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          enabled: curUser.hasFullAccess || (!curUser.hasFullAccess && !technique.isPaidVersionOnly),
          contentPadding: techniqueCardContentPadding,
          onTap: (){},
          title: Text(technique.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                technique.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                  'Breathing Rhythm: ${technique.inhaleDuration}-${technique.firstHoldDuration}-${technique.exhaleDuration}-${technique.secondHoldDuration}'
              )
            ],
          ),
        ),
      ),
    );
  }
}
