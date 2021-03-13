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
    TextStyle headerTextStyle = TextStyle(
        fontSize: 22,
        color: Colors.blueGrey[800]
    );
    EdgeInsets cardPadding = EdgeInsets.all(20);
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
      );
    }).toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            contentPadding: cardPadding,
            tileColor: Colors.blue[50],
            title: Center(
              child: Text(
                widget.headerTitle,
                style: headerTextStyle,
              ),
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
