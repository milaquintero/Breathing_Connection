import 'package:breathing_connection/models/user.dart';
import 'package:flutter/material.dart';
class SettingCard extends StatefulWidget {
  final String settingName;
  final dynamic settingValue;
  final Function callbackFn;
  final bool isLast;
  SettingCard({this.settingName, this.settingValue, this.callbackFn, this.isLast});
  @override
  _SettingCardState createState() => _SettingCardState();
}

class _SettingCardState extends State<SettingCard> {
  @override
  Widget build(BuildContext context) {
    TextStyle settingTextStyle = TextStyle(
        fontSize: 22,
        color: Colors.blueGrey[900]
    );
    EdgeInsets cardPadding = EdgeInsets.all(20);
    //get run time type of value
    Type type = widget.settingValue.runtimeType;
    List<Widget> settingDisplay;
    //if setting type is boolean
    if(type.toString() == "bool"){
      settingDisplay = [
        Container(
          decoration: BoxDecoration(
            border: widget.isLast ? Border() : Border(
                bottom: BorderSide(
                    color: Colors.grey[300],
                    width: widget.isLast ? 0 : 1
                )
            )
          ),
          child: Card(
            margin: EdgeInsets.zero,
            child: ListTile(
                contentPadding: cardPadding,
                leading: Icon(
                    Icons.multitrack_audio_rounded,
                    size: 32,),
                title: Text(
                  widget.settingName,
                  style: settingTextStyle,
                ),
                trailing: Switch(
                  value: widget.settingValue,
                  onChanged: (newVal){
                    widget.callbackFn(newVal);
                },
              ),
            ),
          ),
        )
      ];
    }
    //if setting type is string
    else{
      settingDisplay = [
        Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            contentPadding: cardPadding,
            leading: Icon(
              Icons.color_lens_outlined,
              size: 32,
            ),
            title: Text(
                widget.settingName,
                style: settingTextStyle,
            ),
            trailing: Container(
              padding: EdgeInsets.only(right: 8),
              width: 53,
              height: 45,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.lightBlue[900]
                ),
              ),
            ),
          ),
        )
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
