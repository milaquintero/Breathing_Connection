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
        return Response('[{"isPaidVersionOnly":false,"techniqueID":1,"title":"Box Breathing","tags":["Focus","Anti-Stress"],"description":"Referred to as Four Square or Navy Seal Breathing. Very effective to gain control of your mind during stressful moments. Recommended for 3 to 5 min or more depending on level of practice.","inhaleDuration":4,"firstHoldDuration":4,"exhaleDuration":4,"secondHoldDuration":4,"assetImage":"","inhaleTypeID":1,"exhaleTypeID":2,"categoryAvailabilities":["AM","Emergency"],"associatedUserID":null},{"isPaidVersionOnly":false,"techniqueID":2,"title":"4-7-8 Breathing","tags":["Sleep","Relaxation"],"description":"Known as Relaxed Breathing, developed by Dr Andrew Weil. It helps reduce anxiety, to calm the mind and help sleep better at night. Practice 3 to 4 times a day if possible for better results. Try it for 5 min per session and add more time as needed.","inhaleDuration":4,"firstHoldDuration":7,"exhaleDuration":8,"secondHoldDuration":0,"assetImage":"","inhaleTypeID":1,"exhaleTypeID":2,"categoryAvailabilities":["PM","Emergency"],"associatedUserID":null},{"isPaidVersionOnly":false,"techniqueID":3,"title":"Pranayama","tags":["Focus","Relaxation"],"description":"An ancient practice to control your breathing in a mindful way. Utilized to connect mind and body. Help remove toxins and have healing benefits to the body. Practice 3 to 4 times a day, 5 to 10 min per session.","inhaleDuration":7,"firstHoldDuration":4,"exhaleDuration":8,"secondHoldDuration":4,"assetImage":"","inhaleTypeID":1,"exhaleTypeID":2,"categoryAvailabilities":["PM","AM","Emergency"],"associatedUserID":null},{"isPaidVersionOnly":false,"techniqueID":4,"title":"Equal Breathing","tags":["Focus","Sleep","Relaxation"],"description":"Can be used anytime you feel uncomfortable or having a bad day. Helps sleep faster and quiet the mind. 2 to 5 min per session.","inhaleDuration":4,"firstHoldDuration":0,"exhaleDuration":4,"secondHoldDuration":0,"assetImage":"","inhaleTypeID":1,"exhaleTypeID":1,"categoryAvailabilities":["PM","AM","Emergency"],"associatedUserID":null},{"isPaidVersionOnly":false,"techniqueID":5,"title":"3 Part Breathing","tags":["Relaxation","Awareness"],"description":"Helps calm the mind during stressful or anxious times. Uses the abdomen, diaphragm, and chest to fill Lungs with air. Utilizes breathing using the belly, ribcage and upper chest, then reversing the flow cycle. Practice 3 to 5 min per session.","inhaleDuration":3,"firstHoldDuration":0,"exhaleDuration":3,"secondHoldDuration":0,"assetImage":"","inhaleTypeID":1,"exhaleTypeID":1,"categoryAvailabilities":["PM","AM","Emergency"],"associatedUserID":null},{"isPaidVersionOnly":false,"techniqueID":6,"title":"Mindful Breathing","tags":["Awareness","Relaxation"],"description":"Helps bring awareness to your breathing. Goes from normal breaths to deep breaths. Notice the abdomen expanding by placing your hand on your belly. Imagine peace when breathing in, and let anxiety and worry disappear by breathing out. Practice 10 min per session.","inhaleDuration":2,"firstHoldDuration":0,"exhaleDuration":2,"secondHoldDuration":0,"assetImage":"","inhaleTypeID":1,"exhaleTypeID":1,"categoryAvailabilities":["PM","AM","Emergency"],"associatedUserID":null},{"isPaidVersionOnly":true,"techniqueID":7,"title":"Pursed Lips Breathing","tags":["Calming Down","Performance"],"description":"Used during activities that need assistance to regulate our breathing such as bending over, lifting, or climbing stairs. Can be practiced 4 to 5 times a day. Helps control shortness of breath and to relax when tired or stressed. Practice 3 to 5 minutes per session.","inhaleDuration":2,"firstHoldDuration":0,"exhaleDuration":4,"secondHoldDuration":0,"assetImage":"","inhaleTypeID":1,"exhaleTypeID":3,"categoryAvailabilities":["PM","AM","Emergency"],"associatedUserID":null},{"isPaidVersionOnly":true,"techniqueID":8,"title":"Alternate Nostril Breathing","tags":["Relaxation","Anti-Anxiety"],"description":"Helps relax, lower anxiety and stress, regulate heart rate and enhance cardiovascular functions. Start by alternating joining a thumb and index or middle finger, going from right to left nostrils. Practice 5 minutes per session.","inhaleDuration":4,"firstHoldDuration":0,"exhaleDuration":4,"secondHoldDuration":0,"assetImage":"","inhaleTypeID":1,"exhaleTypeID":1,"categoryAvailabilities":["PM","AM","Emergency"],"associatedUserID":null},{"isPaidVersionOnly":true,"techniqueID":9,"title":"Breath of Fire Breathing","tags":["Focus","Anti-Stress","Energy"],"description":"Helps with chronic fatigue, oxygenates all the organs and helps fill the body with positive energy and awareness. Practice 30 seconds for beginners or 5 to 10 minutes with more experience.","inhaleDuration":1,"firstHoldDuration":0,"exhaleDuration":1,"secondHoldDuration":0,"assetImage":"","inhaleTypeID":1,"exhaleTypeID":1,"categoryAvailabilities":["AM","Emergency"],"associatedUserID":null},{"isPaidVersionOnly":true,"techniqueID":10,"title":"Bellows Breath","tags":["Weight Loss","Energy"],"description":"Helps energize the body, increase alertness and mindfulness. Can help with losing weight by increasing digestive power.","inhaleDuration":1,"firstHoldDuration":0,"exhaleDuration":1,"secondHoldDuration":0,"assetImage":"","inhaleTypeID":1,"exhaleTypeID":1,"categoryAvailabilities":["AM","Emergency"],"associatedUserID":null}]', 200);
      });
      Iterable data = jsonDecode(response.body);
      return data.map((technique) => Technique.fromJson(technique)).toList();
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
      if(op == 'add'){
        Technique updatedSelectedTechnique = await Future.delayed(Duration(seconds: 1), (){
          //TODO: persist actual technique
          selectedTechnique.techniqueID = 11;
          return selectedTechnique;
        });
        return updatedSelectedTechnique;
      }
      else{
        return null;
      }
    }
    catch(error){
      throw new Exception(error);
    }
  }
}