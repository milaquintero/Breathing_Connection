import 'package:breathing_connection/models/daily_reminder_lists.dart';
import 'package:breathing_connection/models/user_settings.dart';
import 'package:flutter/cupertino.dart';

class User with ChangeNotifier{
  int userId;
  String username;
  bool hasFullAccess;
  bool isSubscribedToEmails;
  UserSettings userSettings;
  int amTechniqueID;
  int pmTechniqueID;
  int challengeTechniqueID;
  int emergencyTechniqueID;
  List<int> customTechniqueIDs;
  DailyReminderLists dailyReminderLists;
  User({this.userId, this.username, this.userSettings, this.hasFullAccess, this.isSubscribedToEmails,
    this.amTechniqueID, this.pmTechniqueID, this.challengeTechniqueID, this.emergencyTechniqueID,
    this.customTechniqueIDs, this.dailyReminderLists});
  factory User.fromJson(Map<String, dynamic> json) {
    Iterable jsonCustomTechniques = json['customTechniques'] ?? [];
    return User(
      userId: json['id'],
      username: json['username'],
      hasFullAccess: json['hasFullAccess'],
      isSubscribedToEmails: json['isSubscribedToEmails'],
      amTechniqueID: json['amTechniqueID'],
      pmTechniqueID: json['pmTechniqueID'],
      challengeTechniqueID: json['challengeTechniqueID'],
      emergencyTechniqueID: json['emergencyTechniqueID'],
      customTechniqueIDs: jsonCustomTechniques.map((jsonTechnique) => int.parse(jsonTechnique)).toList(),
      userSettings: UserSettings.fromJson(json['userSettings']),
      dailyReminderLists: DailyReminderLists.fromJson(json['dailyReminderLists'])
    );
  }
  setAllProperties(User user){
    userId = user.userId;
    username = user.username;
    hasFullAccess = user.hasFullAccess;
    isSubscribedToEmails = user.isSubscribedToEmails;
    amTechniqueID = user.amTechniqueID;
    pmTechniqueID = user.pmTechniqueID;
    challengeTechniqueID = user.challengeTechniqueID;
    emergencyTechniqueID = user.emergencyTechniqueID;
    customTechniqueIDs = user.customTechniqueIDs;
    userSettings = user.userSettings;
    dailyReminderLists = user.dailyReminderLists;
  }
  updateSettings(UserSettings newSettings){
    userSettings = newSettings;
    notifyListeners();
  }
  handleChangeTechnique(String op, int selectedTechniqueID, List<String> assetImages){
    if(op == 'Morning'){
      amTechniqueID = selectedTechniqueID;
    }
    else if(op == 'Evening'){
      pmTechniqueID = selectedTechniqueID;
    }
    else if(op == 'Emergency'){
      emergencyTechniqueID = selectedTechniqueID;
    }
    notifyListeners();
  }
  handleCustomTechnique(String op, int selectedTechniqueID){
    if(op == 'add'){
      customTechniqueIDs.add(selectedTechniqueID);
    }
    else if(op == 'remove'){
      customTechniqueIDs.removeWhere((techniqueID){
        return techniqueID == selectedTechniqueID;
      });
    }
    notifyListeners();
  }
  @override
  String toString() {
    return 'UserID: $userId, Username: $username';
  }
}