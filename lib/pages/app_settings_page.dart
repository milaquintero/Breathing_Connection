import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/models/user_settings.dart';
import 'package:breathing_connection/widgets/setting_section.dart';
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

class AppSettingsPage extends StatefulWidget {
  @override
  _AppSettingsPageState createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
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
    mainContent.add(
        SettingSection(
          settingsMap: generalSettings,
          headerTitle: 'General Settings',
          rootCallback: (key, newVal){
            updateUserSettings(context, key, newVal);
          },
        )
    );
    //add sound settings section
    Iterable<MapEntry<String, dynamic>> soundSettings = filterSettings(
        allSettings,
        ['breathingSound', 'backgroundSound', 'vibration']
    );
    mainContent.add(
        SettingSection(
          settingsMap: soundSettings,
          headerTitle: 'Sound Settings',
          rootCallback: (key, newVal){
            updateUserSettings(context, key, newVal);
          },
        )
    );
    //add display settings section
    Iterable<MapEntry<String, dynamic>> displaySettings = filterSettings(
        allSettings,
        ['themeID']
    );
    mainContent.add(
        SettingSection(
          settingsMap: displaySettings,
          headerTitle: 'Display Settings',
          rootCallback: (key, newVal){
            updateUserSettings(context, key, newVal);
          },
        )
    );
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
