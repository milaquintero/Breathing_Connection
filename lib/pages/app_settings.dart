import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:flutter/material.dart';

import '../styles.dart';
class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  @override
  Widget build(BuildContext context) {
    User curUser = UserService.curUser;
    Map<dynamic, dynamic> settingsList = curUser.userSettings.toJson();
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
        child: ListView.builder(
          itemCount: settingsList.entries.length,
          itemBuilder: (context, index){
            //get setting key
            String settingKey = settingsList.keys.elementAt(index);
            //format key display text
            settingKey = settingKey.split(new RegExp(r"(?=[A-Z])")).join(" ");
            settingKey = '${settingKey[0].toUpperCase()}${settingKey.substring(1)}';
            //get setting value
            dynamic settingValue = settingsList.values.elementAt(index);
            //store type of value for dynamic rendering
            Type settingType = settingValue.runtimeType;
            //if setting type is boolean
            if(settingType.toString() == "bool"){
              return Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(settingKey),
                    Switch(
                      value: settingValue,
                      onChanged: (bool){
                        setState(() {
                          settingValue = bool;
                          curUser.userSettings.setProperty(settingKey, settingValue);
                        });
                      },
                    )
                  ],
                ),
              );
            }
            //if setting type is string
            else{
              return Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(settingKey),
                    Text(settingValue.toString())
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
