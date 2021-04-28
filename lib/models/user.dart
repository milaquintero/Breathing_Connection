import 'dart:collection';

import 'package:breathing_connection/models/daily_reminder_lists.dart';
import 'package:breathing_connection/models/user_settings.dart';
import 'package:flutter/cupertino.dart';

class User with ChangeNotifier{
  String userId;
  String username;
  String email;
  bool hasFullAccess;
  bool isSubscribedToEmails;
  UserSettings userSettings;
  int amTechniqueID;
  int pmTechniqueID;
  int challengeTechniqueID;
  int emergencyTechniqueID;
  List<int> customTechniqueIDs;
  DailyReminderLists dailyReminderLists;
  bool isEmailVerified;
  User({this.userId, this.username, this.userSettings, this.hasFullAccess, this.isSubscribedToEmails,
    this.amTechniqueID, this.pmTechniqueID, this.challengeTechniqueID, this.emergencyTechniqueID,
    this.customTechniqueIDs, this.dailyReminderLists, this.email, this.isEmailVerified});
  factory User.fromJson(json) {
    Iterable jsonCustomTechniques = json['customTechniqueIDs'] ?? [];
    return User(
      userId: json['userId'],
      username: json['username'] ?? '',
      hasFullAccess: json['hasFullAccess'],
      isSubscribedToEmails: json['isSubscribedToEmails'],
      isEmailVerified: json['isEmailVerified'] ?? false,
      amTechniqueID: json['amTechniqueID'],
      pmTechniqueID: json['pmTechniqueID'],
      challengeTechniqueID: json['challengeTechniqueID'],
      emergencyTechniqueID: json['emergencyTechniqueID'],
      email: json['email'],
      customTechniqueIDs: List<int>.from(jsonCustomTechniques),
      userSettings: UserSettings.fromJson(json['userSettings']),
      dailyReminderLists: DailyReminderLists.fromJson(json['dailyReminderLists']),
    );
  }
  setAllProperties(User user){
    userId = user.userId;
    username = user.username;
    hasFullAccess = user.hasFullAccess;
    isSubscribedToEmails = user.isSubscribedToEmails;
    isEmailVerified = user.isEmailVerified;
    amTechniqueID = user.amTechniqueID;
    pmTechniqueID = user.pmTechniqueID;
    challengeTechniqueID = user.challengeTechniqueID;
    emergencyTechniqueID = user.emergencyTechniqueID;
    customTechniqueIDs = user.customTechniqueIDs;
    userSettings = user.userSettings;
    dailyReminderLists = user.dailyReminderLists;
    email = user.email;
  }
  updateSettings(UserSettings newSettings){
    userSettings = newSettings;
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