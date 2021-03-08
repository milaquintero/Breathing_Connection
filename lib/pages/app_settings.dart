import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/models/user_settings.dart';
import 'package:breathing_connection/widgets/setting_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../styles.dart';

Function updateUserSettings(context, settingKey, newVal){
  //get user settings from user provider
  UserSettings newSettings = Provider.of<User>(context, listen: false).userSettings;
  //update selected setting in temp variable
  newSettings.setProperty(settingKey, newVal);
  //update actual settings in user provider using function that notifies listeners
  Provider.of<User>(context, listen: false).updateSettings(newSettings);
}

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  @override
  Widget build(BuildContext context) {
    Map <String, dynamic> settingsList = Provider.of<User>(context).userSettings.toJson();
    //set up main content
    List<Widget> mainContent = settingsList.entries.map((setting){
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
          updateUserSettings(context, setting.key, newVal);
        },
      );
    }).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: brandPrimary,
        toolbarHeight: appBarHeight,
        title: Text(
          'App Settings',
          style: appBarTextStyle,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: wellSectionBg,
        child: ListView(
          padding: EdgeInsets.only(top: 32),
          children: mainContent,
        ),
      ),
    );
  }
}
