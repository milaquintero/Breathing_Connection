import 'package:breathing_connection/models/technique.dart';
import 'package:http/http.dart';
import 'dart:convert';

import '../constants.dart';

class TechniqueService{
  static List<Technique> techniques;
  static Future<List<Technique>> techniqueData() async{
    try{
      //PROD
      //Response response = await get('$BASE_URL/techniques');
      //TEST
      Response response = await Future.delayed(Duration(seconds: 1), (){
        return Response('[{"techniqueID": 1,"title": "4-7-8","description": "Fall asleep faster and wake up better recovered.","inhaleDuration": 4,"firstHoldDuration": 7,"exhaleDuration": 8,"secondHoldDuration": 0},{"techniqueID": 2,"title": "Slow Paced Breathing","description": "Lower blood pressure.","inhaleDuration": 4,"firstHoldDuration": 0,"exhaleDuration": 6,"secondHoldDuration": 0},{"techniqueID": 3,"title": "COPD Breathing","description": "Relieve COPD and Asthma Symptoms.","inhaleDuration": 2,"firstHoldDuration": 0,"exhaleDuration": 6,"secondHoldDuration": 0}]', 200);
      });
      Iterable data = jsonDecode(response.body);
      return data.map((technique) => Technique.fromJson(technique)).toList();
    }
    catch(error){
      throw new Exception(error);
    }
  }
}