import 'app_theme.dart';

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
        AppTheme tempAppTheme = value;
        themeID = tempAppTheme.themeID;
        break;
      case "challengeMode":
        challengeMode = value;
    }
  }
  //compare two user settings and return found changes
  static List<String> settingsThatChanged(UserSettings newSettings, UserSettings oldSettings){
    List<String> changes = [];
    if(newSettings != null){
      if(newSettings.vibration != oldSettings.vibration){
        changes.add("vibration");
      }
      if(newSettings.challengeMode != oldSettings.challengeMode){
        changes.add("challengeMode");
      }
      if(newSettings.dailyReminders != oldSettings.dailyReminders){
        changes.add("dailyReminders");
      }
      if(newSettings.breathingSound != oldSettings.breathingSound){
        changes.add("breathingSound");
      }
      if(newSettings.backgroundSound != oldSettings.backgroundSound){
        changes.add("backgroundSound");
      }
      if(newSettings.themeID != oldSettings.themeID){
        changes.add("themeID");
      }
    }
    return changes;
  }
}