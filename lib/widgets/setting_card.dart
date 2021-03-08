import 'package:breathing_connection/models/user.dart';
import 'package:flutter/material.dart';
class SettingCard extends StatefulWidget {
  final String settingName;
  final dynamic settingValue;
  final Function callbackFn;
  SettingCard({this.settingName, this.settingValue, this.callbackFn});
  @override
  _SettingCardState createState() => _SettingCardState();
}

class _SettingCardState extends State<SettingCard> {
  TextStyle settingTextStyle = TextStyle(
    fontSize: 24
  );
  @override
  Widget build(BuildContext context) {
    //get run time type of value
    Type type = widget.settingValue.runtimeType;
    List<Widget> settingDisplay;
    //if setting type is boolean
    if(type.toString() == "bool"){
      settingDisplay = [
        Text(
          widget.settingName,
          style: settingTextStyle,
        ),
        Switch(
          value: widget.settingValue,
          onChanged: (newVal){
            widget.callbackFn(newVal);
          },
        )
      ];
    }
    //if setting type is string
    else{
      settingDisplay = [
        Text(
          widget.settingName,
          style: settingTextStyle,
          ),
        Text(widget.settingValue.toString())
      ];
    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: settingDisplay,
      ),
    );
  }
}
