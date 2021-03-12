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
    TextStyle techniqueTitleStyle = TextStyle(
        fontSize: 22,
        color: Colors.blueGrey[900]
    );
    TextStyle techniqueSubtitleStyle = TextStyle(
        fontSize: 15,
        color: Colors.grey[600]
    );
    EdgeInsets techniqueCardContentPadding = EdgeInsets.all(20);
    return Container(
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          enabled: curUser.hasFullAccess || (!curUser.hasFullAccess && !technique.isPaidVersionOnly),
          contentPadding: techniqueCardContentPadding,
          onTap: (){},
          title: Text(
              technique.title,
              style: techniqueTitleStyle,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                technique.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: techniqueSubtitleStyle,
              ),
              Text(
                'Breathing Rhythm: ${technique.inhaleDuration}-${technique.firstHoldDuration}-${technique.exhaleDuration}-${technique.secondHoldDuration}',
                style: techniqueSubtitleStyle,
              )
            ],
          ),
          trailing: IconButton(
            icon: Icon(
                Icons.more_vert,
                size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
