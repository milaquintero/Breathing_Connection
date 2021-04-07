import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/widgets/fancy_bullet_list.dart';
import 'package:breathing_connection/widgets/fancy_scrollable_page.dart';
import 'package:breathing_connection/widgets/fancy_tag.dart';
import 'package:breathing_connection/widgets/fancy_text_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ProLicensePage extends StatefulWidget {
  final BuildContext rootContext;
  ProLicensePage({this.rootContext});

  @override
  _ProLicensePageState createState() => _ProLicensePageState();
}

class _ProLicensePageState extends State<ProLicensePage> {
  AppTheme appTheme;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //selected theme data
    appTheme = Provider.of<CurrentThemeHandler>(widget.rootContext).currentTheme;
  }
  @override
  Widget build(BuildContext context) {
    return FancyScrollablePage(
      withIconHeader: false,
      pageTitle: 'Pro License',
      bgColor: appTheme.bgSecondaryColor,
      appBarColor: appTheme.brandPrimaryColor,
      decorationPrimaryColor: appTheme.decorationPrimaryColor,
      decorationSecondaryColor: appTheme.decorationSecondaryColor,
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
                  color: appTheme.textSecondaryColor
              ),
            ),
          ),
          FancyTextContainer(
            icon: Icons.add_moderator,
            iconColor: appTheme.textPrimaryColor,
            iconBgColor: appTheme.brandAccentColor,
            title: "Additional Features",
            textColor: appTheme.textPrimaryColor,
            bgColor: appTheme.brandPrimaryColor,
            bgGradientComparisonColor: appTheme.bgAccentColor,
            margin: EdgeInsets.only(top: 72, bottom: 36),
            child: Padding(
              padding: EdgeInsets.only(top: 16, bottom: 0, left: 20, right: 20),
              child: FancyBulletList(
                bulletIcon: Icons.check_circle,
                bulletIconColor: appTheme.bulletListIconColor,
                textColor: appTheme.textPrimaryColor,
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
            iconColor: appTheme.textPrimaryColor,
            iconBgColor: appTheme.brandAccentColor,
            title: "Pricing",
            textColor: appTheme.textPrimaryColor,
            bgColor: appTheme.brandPrimaryColor,
            bgGradientComparisonColor: appTheme.bgAccentColor,
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
                      color: appTheme.textPrimaryColor,
                      fontSize: 24
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                  backgroundColor: appTheme.brandPrimaryColor
              ),
            ),
          )
        ],
      ),
    );
  }
}
