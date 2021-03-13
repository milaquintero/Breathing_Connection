import 'package:breathing_connection/models/user_settings.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier{
  int userId;
  String username;
  bool hasFullAccess;
  UserSettings userSettings;
  Technique amTechnique;
  Technique pmTechnique;
  Technique challengeTechnique;
  Technique emergencyTechnique;
  List<Technique> customTechniques;
  User({this.userId, this.username, this.userSettings, this.hasFullAccess,
    this.amTechnique, this.pmTechnique, this.challengeTechnique, this.emergencyTechnique,
    this.customTechniques});
  factory User.fromJson(Map<String, dynamic> json) {
    Iterable jsonCustomTechniques = json['customTechniques'];
    return User(
      userId: json['id'],
      username: json['username'],
      hasFullAccess: json['hasFullAccess'],
      amTechnique: Technique.fromJson(json['amTechnique']),
      pmTechnique: Technique.fromJson(json['pmTechnique']),
      challengeTechnique: Technique.fromJson(json['challengeTechnique']),
      emergencyTechnique: Technique.fromJson(json['emergencyTechnique']),
      customTechniques: jsonCustomTechniques.map((jsonTechnique) => Technique.fromJson(jsonTechnique)).toList(),
      userSettings: UserSettings.fromJson(json['userSettings'])
    );
  }
  setAllProperties(User user){
    userId = user.userId;
    username = user.username;
    hasFullAccess = user.hasFullAccess;
    amTechnique = user.amTechnique;
    pmTechnique = user.pmTechnique;
    challengeTechnique = user.challengeTechnique;
    emergencyTechnique = user.emergencyTechnique;
    customTechniques = user.customTechniques;
    userSettings = user.userSettings;
  }
  updateSettings(UserSettings newSettings){
    userSettings = newSettings;
    notifyListeners();
  }
  @override
  String toString() {
    return 'UserID: $userId, Username: $username';
  }
}