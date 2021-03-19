import 'package:breathing_connection/models/technique.dart';
import 'package:http/http.dart';
import 'dart:convert';

import '../constants.dart';

class TechniqueService{
  static Future<List<Technique>> techniqueData() async{
    try{
      //PROD
      //Response response = await get('$BASE_URL/techniques');
      //TEST
      Response response = await Future.delayed(Duration(seconds: 1), (){
        return Response('[{"isPaidVersionOnly":false,"techniqueID":1,"title":"4-7-8","description":"Fall asleep faster and wake up better recovered.","inhaleDuration":4,"firstHoldDuration":7,"exhaleDuration":8,"secondHoldDuration":0,"assetImage":""},{"isPaidVersionOnly":false,"techniqueID":2,"title":"Slow Paced Breathing","description":"Lower blood pressure.","inhaleDuration":4,"firstHoldDuration":0,"exhaleDuration":6,"secondHoldDuration":0,"assetImage":""},{"isPaidVersionOnly":false,"techniqueID":3,"title":"COPD Breathing","description":"Relieve COPD and Asthma Symptoms.","inhaleDuration":2,"firstHoldDuration":0,"exhaleDuration":6,"secondHoldDuration":0,"assetImage":""},{"isPaidVersionOnly":true,"techniqueID":4,"title":"Custom Technique 1","description":"Custom Technique 1.","inhaleDuration":2,"firstHoldDuration":2,"exhaleDuration":2,"secondHoldDuration":2,"assetImage":""},{"isPaidVersionOnly":true,"techniqueID":5,"title":"Custom Technique 2","description":"Custom Technique 2.","inhaleDuration":2,"firstHoldDuration":2,"exhaleDuration":2,"secondHoldDuration":2,"assetImage":""},{"isPaidVersionOnly":true,"techniqueID":6,"title":"Custom Technique 3","description":"Custom Technique 3.","inhaleDuration":2,"firstHoldDuration":2,"exhaleDuration":2,"secondHoldDuration":2,"assetImage":""},{"isPaidVersionOnly":true,"techniqueID":7,"title":"Custom Technique 4","description":"Custom Technique 4.","inhaleDuration":2,"firstHoldDuration":2,"exhaleDuration":2,"secondHoldDuration":2,"assetImage":""}]', 200);
      });
      Iterable data = jsonDecode(response.body);
      return data.map((technique) => Technique.fromJson(technique)).toList();
    }
    catch(error){
      throw new Exception(error);
    }
  }
}