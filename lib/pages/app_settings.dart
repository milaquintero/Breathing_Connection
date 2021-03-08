import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/models/user_settings.dart';
import 'package:breathing_connection/widgets/setting_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../styles.dart';

void updateUserSettings(context, settingKey, newVal){
  //get user settings from user provider
  UserSettings newSettings = Provider.of<User>(context, listen: false).userSettings;
  //update selected setting in temp variable
  newSettings.setProperty(settingKey, newVal);
  //update actual settings in user provider using function that notifies listeners
  Provider.of<User>(context, listen: false).updateSettings(newSettings);
}

Iterable<MapEntry<String, dynamic>> filterSettings(Map<String, dynamic> allSettings, List<String>desiredKeys){
  return allSettings.entries.where(
          (setting) => desiredKeys.indexOf(setting.key) != -1
  );
}

List<Widget> addSettingSection(
    Iterable<MapEntry<String, dynamic>> unformattedMap, BuildContext context, String headerTitle
    ){
  List<Widget> newSection = [];
  TextStyle headerTextStyle = TextStyle(
      fontSize: 22,
      color: Colors.blueGrey[800]
  );
  EdgeInsets cardPadding = EdgeInsets.all(20);
  //add section header
  Card sectionHeader = Card(
    margin: EdgeInsets.zero,
    child: ListTile(
      contentPadding: cardPadding,
      tileColor: Colors.blue[50],
      title: Center(
        child: Text(
            headerTitle,
            style: headerTextStyle,
        ),
      ),
    ),
  );
  newSection.add(sectionHeader);
  //add setting cards
  List<Widget> settingCards = unformattedMap.map((setting){
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
  newSection.addAll(settingCards);
  return newSection;
}

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  @override
  Widget build(BuildContext context) {
    Map <String, dynamic> allSettings = Provider.of<User>(context).userSettings.toJson();
    //set up main content
    List<Widget> mainContent = [];
    //add general settings section
    Iterable<MapEntry<String, dynamic>> generalSettings = filterSettings(
        allSettings,
        ['dailyReminders']
    );
    mainContent.addAll(addSettingSection(generalSettings, context, 'General Settings'));
    //add sound settings section
    Iterable<MapEntry<String, dynamic>> soundSettings = filterSettings(
        allSettings,
        ['breathingSound', 'backgroundSound', 'vibration']
    );
    mainContent.addAll(addSettingSection(soundSettings, context, 'Sound Settings'));
    //add display settings section
    Iterable<MapEntry<String, dynamic>> displaySettings = filterSettings(
        allSettings,
        ['themeID']
    );
    mainContent.addAll(addSettingSection(displaySettings, context, 'Display Settings'));
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
          children: mainContent,
        ),
      ),
    );
  }
}
