import 'dart:convert';
import 'package:breathing_connection/constants.dart';
import 'package:http/http.dart';
import 'package:breathing_connection/models/user.dart';
//shareable user resource with GET method to retrieve user data
class UserService {
  static User curUser;
  //get user data from backend
  static Future<User> userData(userID) async{
    try{
      //PROD
      //Response userResponse = await get('$BASE_URL/users/$userID');
      //TEST
      Response userResponse = await Future.delayed(Duration(seconds: 1), (){
        return Response('{"id":1,"username":"Viznaga","hasFullAccess": false,"email":"viz@viz.com","amTechnique":{"techniqueID":1,"title":"4-7-8","description":"Fall asleep faster and wake up better recovered.","inhaleDuration":4,"firstHoldDuration":7,"exhaleDuration":8,"secondHoldDuration":0},"pmTechnique":{"techniqueID":2,"title":"Slow Paced Breathing","description":"Lower blood pressure.","inhaleDuration":4,"firstHoldDuration":0,"exhaleDuration":6,"secondHoldDuration":0},"challengeTechnique":{"techniqueID":3,"title":"COPD Breathing","description":"Relieve COPD and Asthma Symptoms.","inhaleDuration":2,"firstHoldDuration":0,"exhaleDuration":6,"secondHoldDuration":0},"customTechniques":[{"techniqueID":1,"title":"4-7-8","description":"Fall asleep faster and wake up better recovered.","inhaleDuration":4,"firstHoldDuration":7,"exhaleDuration":8,"secondHoldDuration":0}],"appSettings":{"breathingSound":true,"backgroundSound":true,"vibration":true,"dailyReminders":true,"themeID":1}}', 200);
      });
      return User.fromJson(jsonDecode(userResponse.body));
    }
    catch(error){
      throw new Exception(error);
    }
  }
}