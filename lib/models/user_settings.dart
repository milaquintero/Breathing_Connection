import 'package:flutter/cupertino.dart';

class UserSettings{
  bool breathingSound;
  bool backgroundSound;
  bool vibration;
  bool dailyReminders;
  int themeID;
  bool challengeMode;
  UserSettings({this.breathingSound, this.backgroundSound,
    this.vibration, this.dailyReminders, this.themeID, this.challengeMode});
  factory UserSettings.fromJson(json){
    return UserSettings(
      breathingSound: json['breathingSound'],
      backgroundSound: json['backgroundSound'],
      vibration: json['vibration'],
      dailyReminders: json['dailyReminders'],
      themeID: json['themeID'],
      challengeMode: json['challengeMode']
    );
  }
  Map<String, dynamic> toJson(){
    return {
      "breathingSound": breathingSound,
      "backgroundSound": backgroundSound,
      "vibration": vibration,
      "dailyReminders": dailyReminders,
      "themeID": themeID,
      "challengeMode": challengeMode
    };
  }
  setProperty(String property, dynamic value){
    switch(property){
      case "breathingSound":
        breathingSound = value;
        break;
      case "backgroundSound":
        backgroundSound = value;
        break;
      case "vibration":
        vibration = value;
        break;
      case "dailyReminders":
        dailyReminders = value;
        break;
      case "themeID":
        themeID = value;
        break;
      case "challengeMode":
        challengeMode = value;
    }
  }
}