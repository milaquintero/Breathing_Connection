import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/view_technique_details_handler.dart';
import 'package:breathing_connection/widgets/fancy_instructional_text.dart';
import 'package:breathing_connection/widgets/fancy_scrollable_page.dart';
import 'package:breathing_connection/widgets/fancy_tag.dart';
import 'package:breathing_connection/widgets/fancy_text_container.dart';
import 'package:flutter/material.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:provider/provider.dart';
import 'package:breathing_connection/models/inhale_exhale_type.dart';

import '../styles.dart';

class TechniqueDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {//screen height
    Technique techniqueToDisplay = Provider.of<ViewTechniqueDetailsHandler>(context).techniqueBeingViewed;
    MainData mainData = Provider.of<MainData>(context);
    InhaleExhaleType inhaleType = mainData.inhaleExhaleTypes.firstWhere((inhaleExhaleType) => inhaleExhaleType.inhaleExhaleTypeID == techniqueToDisplay.inhaleTypeID);
    InhaleExhaleType exhaleType = mainData.inhaleExhaleTypes.firstWhere((inhaleExhaleType) => inhaleExhaleType.inhaleExhaleTypeID == techniqueToDisplay.exhaleTypeID);
    return FancyScrollablePage(
      headerIconColor: Colors.grey[50],
      bgColor: Colors.cyan[50],
      pageTitle: 'Technique Details',
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 32),
            child: Text(
              techniqueToDisplay.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue[900]
              ),
            ),
          ),
          FancyInstructionalText(
            icon: Icons.analytics,
            iconColor: Colors.grey[50],
            iconBgColor: Colors.grey[850],
            bgColor: brandPrimary,
            title: 'Description',
            subtitle: techniqueToDisplay.description,
            textColor: Colors.white,
            margin: EdgeInsets.only(top: 72, bottom: 8),
            subtitleAlignment: TextAlign.start,
          ),
          FancyTextContainer(
            icon: Icons.integration_instructions,
            iconColor: Colors.grey[50],
            iconBgColor: Colors.grey[850],
            bgColor: brandPrimary,
            title: 'Breathing Rhythm',
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Inhale: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              )
                          ),
                          Text(
                              '${techniqueToDisplay.inhaleDuration} seconds ',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              )
                          ),
                          Text(
                              '(${inhaleType.description})',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              )
                          )
                        ]
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'First Hold: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              )
                          ),
                          Text(
                              '${techniqueToDisplay.firstHoldDuration} seconds',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              )
                          )
                        ]
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Exhale: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              )
                          ),
                          Text(
                              '${techniqueToDisplay.exhaleDuration} seconds ',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              )
                          ),
                          Text(
                              '(${exhaleType.description})',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              )
                          )
                        ]
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4, bottom: 12),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Second Hold: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              )
                          ),
                          Text(
                              '${techniqueToDisplay.secondHoldDuration} seconds',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              )
                          )
                        ]
                    ),
                  )
                ],
              ),
            ),
            textColor: Colors.white,
            margin: EdgeInsets.only(top: 68, bottom: 44),
            subtitleAlignment: TextAlign.justify,
          ),
          FancyTextContainer(
            icon: Icons.pie_chart,
            iconColor: Colors.grey[50],
            iconBgColor: Colors.grey[850],
            bgColor: brandPrimary,
            title: 'Tags',
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: techniqueToDisplay.tags.length,
                  itemBuilder: (context, index){
                    return FancyTag(
                      tagName: techniqueToDisplay.tags[index],
                    );
                  }
              ),
            ),
            textColor: Colors.white,
            margin: EdgeInsets.only(top: 68, bottom: 44),
            subtitleAlignment: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
