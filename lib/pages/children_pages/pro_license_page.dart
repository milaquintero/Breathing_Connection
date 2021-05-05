import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
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
  MainData mainData;
  void _purchase(String op){
    //TODO: handle purchasing subscription
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //selected theme data
    appTheme = Provider.of<CurrentThemeHandler>(widget.rootContext).currentTheme;
    //app main data
    mainData = Provider.of<MainData>(widget.rootContext);
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
      appBarHeight: mainData.appBarHeight,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 36, bottom: 16),
            child: Text(
              mainData.proPageHeaderText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 40,
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
                  GestureDetector(
                    onTap: (){
                      //initiate payment for monthly subscription
                      _purchase('monthly');
                    },
                    child: FancyTag(
                      tagName: "\$1.49",
                      hasFooter: true,
                      tagFooter: "(BILLED MONTHLY)",
                      footerFontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      //initiate payment for annual subscription
                      _purchase('annually');
                    },
                    child: FancyTag(
                      tagName: "\$9.99",
                      hasFooter: true,
                      tagFooter: "(BILLED ANNUALLY)",
                      footerFontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 44),
            child: TextButton(
              onPressed: (){
                //initiate payment for annual subscription
                _purchase('annually');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                child: Text(
                  mainData.proPageSubmitBtnText,
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
