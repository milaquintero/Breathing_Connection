import 'dart:convert';
import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/models/user_settings.dart';
import 'package:http/http.dart';
import 'package:breathing_connection/models/user.dart';
//shareable user resource with GET method to retrieve user data
class UserService {
  //get user data from backend
  static Future<User> userData(userID) async{
    try{
      //PROD
      //Response userResponse = await get('$BASE_URL/users/$userID');
      //TEST
      Response userResponse = await Future.delayed(Duration(seconds: 1), (){
        return Response('{"id":1,"username":"Viznaga","email":"viz@viz.com","hasFullAccess":true,"isSubscribedToEmails":false,"amTechniqueID":1,"pmTechniqueID":2,"challengeTechniqueID":3,"emergencyTechniqueID":4,"customTechniqueIDs":[],"dailyReminderLists":{"challengeModeTimes":["2021-04-07T8:00:00.000","2021-04-07T12:00:00.000","2021-04-07T18:00:00.000"],"regularTimes":["2021-04-07T08:00:00.000","2021-04-07T18:00:00.000"]},"userSettings":{"breathingSound":true,"backgroundSound":true,"vibration":true,"dailyReminders":true,"themeID":1,"challengeMode":false}}', 200);
      });
      return User.fromJson(jsonDecode(userResponse.body));
    }
    catch(error){
      throw new Exception(error);
    }
  }
  static Future<Technique> handleCustomTechnique(String op, Technique selectedTechnique) async{
    try{
      //PROD
      //Response customTechniqueResponse = await get('$BASE_URL/users/$userID');
      //TEST
      Technique updatedSelectedTechnique = await Future.delayed(Duration(seconds: 1), (){
        selectedTechnique.techniqueID = 8;
        return selectedTechnique;
      });
      return updatedSelectedTechnique;
    }
    catch(error){
      throw new Exception(error);
    }
  }

  static Future<void> handleUpdateSettings(UserSettings newSettings){
    //TODO: persist changes to settings
  }
}