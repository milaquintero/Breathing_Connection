import 'dart:convert';
import 'package:breathing_connection/models/technique.dart';
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
        return Response('{"id":1,"username":"Viznaga","email":"viz@viz.com","hasFullAccess":true,"isSubscribedToEmails":true,"amTechnique":{"isPaidVersionOnly":false,"techniqueID":1,"title":"4-7-8","description":"Fall asleep faster and wake up better recovered.","inhaleDuration":4,"firstHoldDuration":7,"exhaleDuration":8,"secondHoldDuration":0,"assetImage":"assets/day.jpg"},"pmTechnique":{"isPaidVersionOnly":false,"techniqueID":2,"title":"Slow Paced Breathing","description":"Lower blood pressure.","inhaleDuration":4,"firstHoldDuration":0,"exhaleDuration":6,"secondHoldDuration":0,"assetImage":"assets/night.jpg"},"challengeTechnique":{"isPaidVersionOnly":false,"techniqueID":3,"title":"COPD Breathing","description":"Relieve COPD and Asthma Symptoms.","inhaleDuration":2,"firstHoldDuration":0,"exhaleDuration":6,"secondHoldDuration":0,"assetImage":"assets/challenge.jpg"},"emergencyTechnique":{"isPaidVersionOnly":false,"techniqueID":3,"title":"COPD Breathing","description":"Relieve COPD and Asthma Symptoms.","inhaleDuration":2,"firstHoldDuration":0,"exhaleDuration":6,"secondHoldDuration":0,"assetImage":"assets/emergency.jpg"},"customTechniques":[{"isPaidVersionOnly":true,"techniqueID":4,"title":"Custom Technique 1","description":"Custom Technique 1.","inhaleDuration":2,"firstHoldDuration":2,"exhaleDuration":2,"secondHoldDuration":2,"assetImage":"assets/custom.jpg"},{"isPaidVersionOnly":true,"techniqueID":5,"title":"Custom Technique 2","description":"Custom Technique 2.","inhaleDuration":2,"firstHoldDuration":2,"exhaleDuration":2,"secondHoldDuration":2,"assetImage":"assets/custom.jpg"}],"userSettings":{"breathingSound":true,"backgroundSound":true,"vibration":true,"dailyReminders":true,"themeID":1}}', 200);
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
}