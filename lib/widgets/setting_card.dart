import 'package:breathing_connection/models/app_theme.dart';
import 'package:flutter/material.dart';

import 'dialog_theme_selection.dart';
class SettingCard extends StatefulWidget {
  final String settingName;
  final dynamic settingValue;
  final Function callbackFn;
  final bool isLast;
  final Color textColor;
  final Color cardBgColor;
  final Color cardBorderColor;
  final Color cardIconColor;
  final Color cardActionColor;
  final Color curThemePrimaryColor;
  final List<dynamic> selectionList;
  SettingCard({this.settingName, this.settingValue, this.callbackFn, this.isLast,
  this.textColor, this.cardBgColor, this.cardBorderColor, this.cardIconColor,
  this.cardActionColor, this.selectionList, this.curThemePrimaryColor});
  @override
  _SettingCardState createState() => _SettingCardState();
}

class _SettingCardState extends State<SettingCard> {
  TextStyle settingTextStyle;
  EdgeInsets cardPadding;
  //get run time type of value
  Type type;
  List<Widget> settingDisplay;
  double screenHeight;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }
  @override
  Widget build(BuildContext context) {
    settingTextStyle = TextStyle(
        fontSize: 22,
        color: widget.textColor
    );
    cardPadding = EdgeInsets.all(20);
    //get run time type of value
    type = widget.settingValue.runtimeType;
    //screen height
    screenHeight = MediaQuery.of(context).size.height;
    //if setting type is boolean
    if(type.toString() == "bool"){
      settingDisplay = [
        Container(
          decoration: BoxDecoration(
              border: widget.isLast ? Border() : Border(
                  bottom: BorderSide(
                      color: widget.cardBorderColor,
                      width: widget.isLast ? 0 : 1
                  )
              )
          ),
          child: Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              contentPadding: cardPadding,
              tileColor: widget.cardBgColor,
              leading: Icon(
                Icons.multitrack_audio_rounded,
                size: 32,
                color: widget.cardIconColor,
              ),
              title: Text(
                widget.settingName,
                style: settingTextStyle,
              ),
              trailing: Switch(
                value: widget.settingValue,
                activeColor: widget.cardActionColor,
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
            tileColor: widget.cardBgColor,
            leading: Icon(
              Icons.color_lens_outlined,
              size: 32,
              color: widget.cardIconColor,
            ),
            title: Text(
              widget.settingName,
              style: settingTextStyle,
            ),
            trailing: GestureDetector(
              onTap: (){
                //handle changing theme with selection dialog
                if(widget.settingName.toLowerCase().contains('theme') && widget.selectionList != null){
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context){
                        return DialogThemeSelection(
                          titleText: 'Select Theme',
                          titlePadding: EdgeInsets.symmetric(vertical: 12),
                          headerIcon: Icons.color_lens_sharp,
                          headerBgColor: widget.curThemePrimaryColor,
                          themeList: widget.selectionList,
                          cbFunction: (AppTheme selectedTheme){
                            //send back selected theme
                            widget.callbackFn(selectedTheme);
                          },
                        );
                      }
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.only(right: 8),
                width: 53,
                height: 45,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: widget.curThemePrimaryColor,
                      border: Border.all(
                          color: widget.cardIconColor.withOpacity(0.1),
                          width: 2
                      )
                  ),
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
