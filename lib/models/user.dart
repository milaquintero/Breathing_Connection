import 'dart:convert';
import 'package:breathing_connection/models/user_settings.dart';
import 'package:breathing_connection/models/technique.dart';

class User{
  int userId;
  String username;
  bool hasFullAccess;
  UserSettings userSettings;
  Technique amTechnique;
  Technique pmTechnique;
  Technique challengeTechnique;
  List<Technique> customTechniques;
  User({this.userId, this.username, this.userSettings, this.hasFullAccess,
    this.amTechnique, this.pmTechnique, this.challengeTechnique,
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
      customTechniques: jsonCustomTechniques.map((jsonTechnique) => Technique.fromJson(jsonTechnique)).toList(),
      userSettings: UserSettings.fromJson(json['userSettings'])
    );
  }
  @override
  String toString() {
    return 'UserID: $userId, Username: $username';
  }
}