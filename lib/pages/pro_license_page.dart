import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/styles.dart';
import 'package:breathing_connection/widgets/fancy_bullet_list.dart';
import 'package:breathing_connection/widgets/fancy_page.dart';
import 'package:breathing_connection/widgets/fancy_scrollable_page.dart';
import 'package:breathing_connection/widgets/fancy_tag.dart';
import 'package:breathing_connection/widgets/fancy_text_container.dart';
import 'package:flutter/material.dart';
import 'package:breathing_connection/models/nav_link.dart';
import 'package:provider/provider.dart';
class ProLicensePage extends StatefulWidget {
  final BuildContext rootContext;
  ProLicensePage({this.rootContext});

  @override
  _ProLicensePageState createState() => _ProLicensePageState();
}

class _ProLicensePageState extends State<ProLicensePage> {
  @override
  Widget build(BuildContext context) {
    return FancyScrollablePage(
      withIconHeader: false,
      headerColor: brandPrimary,
      pageTitle: 'Pro License',
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 32),
            child: Text(
              'Breathe better with Breathing Connection Pro',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue[900]
              ),
            ),
          ),
          FancyTextContainer(
            icon: Icons.add_moderator,
            iconColor: Colors.grey[50],
            iconBgColor: Colors.grey[850],
            title: "Additional Features",
            textColor: Colors.grey[50],
            bgColor: brandPrimary,
            margin: EdgeInsets.only(top: 72, bottom: 36),
            child: Padding(
              padding: EdgeInsets.only(top: 16, bottom: 0, left: 20, right: 20),
              child: FancyBulletList(
                bulletIcon: Icons.check_circle,
                bulletIconColor: Colors.teal[300],
                textColor: Colors.grey[50],
                listItems: [
                  "Unlock all Breathing Techniques",
                  "Gain ability to create Custom Techniques",
                  "New music, sounds and images every month",
                  "Unlock the Challenge Technique feature"
                ],
              ),
            ),
          ),
          FancyTextContainer(
            icon: Icons.account_balance,
            iconColor: Colors.grey[50],
            iconBgColor: Colors.grey[850],
            title: "Pricing",
            textColor: Colors.grey[50],
            bgColor: brandPrimary,
            margin: EdgeInsets.only(top: 52, bottom: 36),
            child: Padding(
              padding: EdgeInsets.only(top: 12, bottom: 0, left: 20, right: 20),
              child: Column(
                children: [
                  FancyTag(
                    tagName: "\$0.99",
                    hasFooter: true,
                    tagFooter: "(BILLED MONTHLY)",
                    footerFontSize: 14,
                  ),
                  FancyTag(
                    tagName: "\$9.99",
                    hasFooter: true,
                    tagFooter: "(BILLED ANNUALLY)",
                    footerFontSize: 14,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 44),
            child: TextButton(
              onPressed: (){
                //TODO: initiate google play payment
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                child: Text(
                  'Get It Now',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                  backgroundColor: brandPrimary
              ),
            ),
          )
        ],
      ),
    );
  }
}
