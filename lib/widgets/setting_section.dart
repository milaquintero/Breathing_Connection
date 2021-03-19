import 'package:breathing_connection/widgets/setting_card.dart';
import 'package:flutter/material.dart';
class SettingSection extends StatefulWidget {
  final String headerTitle;
  final Iterable<MapEntry<String, dynamic>> settingsMap;
  final Function rootCallback;
  SettingSection({this.headerTitle, this.settingsMap, this.rootCallback});
  @override
  _SettingSectionState createState() => _SettingSectionState();
}

class _SettingSectionState extends State<SettingSection> {
  @override
  Widget build(BuildContext context) {
    //format setting cards
    List<Widget> settingCards = widget.settingsMap.map((setting){
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
        callbackFn: (newVal){
          widget.rootCallback(setting.key, newVal);
        },
        isLast: (widget.settingsMap.last.toString() == setting.toString())
      );
    }).toList();
    //screen height
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRect(
          child: Container(
            color: Colors.teal[600],
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                    left: -80,
                    top: -100,
                    child: Container(
                      height: 400,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(300),
                        color: Colors.blueGrey[400],
                      ),
                    )
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: screenHeight / 36),
                  child: Center(
                    child: Text(
                      widget.headerTitle,
                      style: TextStyle(
                          fontSize: screenHeight / 24,
                          color: Colors.white
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
}
