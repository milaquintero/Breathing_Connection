import 'package:breathing_connection/widgets/setting_card.dart';
import 'package:flutter/material.dart';
class SettingSection extends StatefulWidget {
  final String headerTitle;
  final Iterable<MapEntry<String, dynamic>> settingsMap;
  final Function rootCallback;
  final Color headerBgColor;
  final Color headerTextColor;
  final Color cardTextColor;
  final Color headerDecorationColor;
  final Color cardBgColor;
  final Color cardBorderColor;
  final Color cardIconColor;
  final Color cardActionColor;
  final Color curThemePrimaryColor;
  final List<dynamic> selectionList;
  SettingSection({this.headerTitle, this.settingsMap, this.rootCallback,
    this.headerBgColor, this.headerTextColor, this.cardTextColor,
    this.headerDecorationColor, this.cardBgColor, this.cardBorderColor,
    this.cardIconColor, this.cardActionColor, this.selectionList,
    this.curThemePrimaryColor});
  @override
  _SettingSectionState createState() => _SettingSectionState();
}

class _SettingSectionState extends State<SettingSection> {
  double screenHeight;
  List<Widget> settingCards;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //screen height
    screenHeight = MediaQuery.of(context).size.height;
    //format setting cards on init
    buildSectionCards();
  }
  @override
  void didUpdateWidget(covariant SettingSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    //format setting cards when setting changes
    buildSectionCards();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRect(
          child: Container(
            color: widget.headerBgColor,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                    left: -80,
                    top: -100,
                    child: Container(
                      height: 450,
                      width: 450,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(300),
                        gradient: RadialGradient(
                          colors: [Colors.blueGrey[400], Color.lerp(widget.headerDecorationColor, Colors.blueGrey[400], 0.01), widget.headerDecorationColor],
                          center: Alignment(0.6, 0.3),
                          focal: Alignment(0.3, -0.1),
                          focalRadius: 0.5,
                        ),
                      ),
                    )
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 28),
                  child: Center(
                    child: Text(
                      widget.headerTitle,
                      style: TextStyle(
                          fontSize: 30,
                          color: widget.headerTextColor
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: settingCards,
        )
      ],
    );
  }
  void buildSectionCards(){
    //format setting cards
    settingCards = widget.settingsMap.map((setting){
      String name = setting.key;
      //remove ID from displayed name if present
      if(name.indexOf('ID') != -1){
        name = name.substring(0, name.indexOf('ID'));
      }
      //camel case to title case
      name = name.split(new RegExp(r"(?=[A-Z])")).join(" ");
      name = '${name[0].toUpperCase()}${name.substring(1)}';
      //add setting card to list
      return SettingCard(
          settingName: name,
          settingValue: setting.value,
          textColor: widget.cardTextColor,
          cardBgColor: widget.cardBgColor,
          cardBorderColor: widget.cardBorderColor,
          cardIconColor: widget.cardIconColor,
          cardActionColor: widget.cardActionColor,
          selectionList: widget.selectionList,
          curThemePrimaryColor: widget.curThemePrimaryColor,
          callbackFn: (newVal){
            widget.rootCallback(setting.key, newVal);
          },
          isLast: (widget.settingsMap.last.toString() == setting.toString())
      );
    }).toList();
  }
}
