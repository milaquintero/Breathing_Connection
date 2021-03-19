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
    bool shouldBeEnabled = curUser.hasFullAccess || (!curUser.hasFullAccess && !technique.isPaidVersionOnly);
    Color listTileBg = shouldBeEnabled ? Colors.white : Colors.blueGrey[400];
    Color titleColor = shouldBeEnabled ? Colors.blueGrey[900] : Colors.grey[400];
    Color subtitleColor = shouldBeEnabled ? Colors.grey[600] : Colors.grey[400];
    Color borderColor = shouldBeEnabled ? Colors.grey[300] : Colors.blueGrey[300];
    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
              color: borderColor,
            )
        ),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          enabled: shouldBeEnabled,
          contentPadding: EdgeInsets.all(20),
          onTap: (){},
          tileColor: listTileBg,
          title: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
                technique.title,
                style: TextStyle(
                    fontSize: 22,
                    color: titleColor
                ),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                technique.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 15,
                    color: subtitleColor
                ),
              ),
              Text(
                'Breathing Rhythm: ${technique.inhaleDuration}-${technique.firstHoldDuration}-${technique.exhaleDuration}-${technique.secondHoldDuration}',
                style: TextStyle(
                    fontSize: 15,
                    color: subtitleColor
                ),
              )
            ],
          ),
          trailing: shouldBeEnabled ? IconButton(
            icon: Icon(
              Icons.more_vert,
              size: 32,
            ),
            tooltip: technique.title + ' Technique Options',
          ) : Container(
            width: 60,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.blueGrey[300],
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.blueGrey
              )
            ),
            child: Text(
                'PRO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
            ),
          ),
        ),
      ),
    );
  }
}
