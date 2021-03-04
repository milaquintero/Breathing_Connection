import 'package:breathing_connection/models/technique.dart';
import 'package:flutter/material.dart';

import '../styles.dart';
class TechniqueCard extends StatelessWidget {
  final Technique technique;
  TechniqueCard({this.technique});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: techniqueCardContainerPadding,
      child: Card(
        child: ListTile(
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
