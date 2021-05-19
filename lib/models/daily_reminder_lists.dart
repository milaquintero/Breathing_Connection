import 'package:cloud_firestore/cloud_firestore.dart';

class DailyReminderLists{
  List<Timestamp> challengeModeTimes;
  List<Timestamp> regularTimes;
  DailyReminderLists({this.challengeModeTimes, this.regularTimes});
  factory DailyReminderLists.fromJson(json){
    Iterable jsonChallengeModeTimes = json['challengeModeTimes'];
    Iterable jsonRegularTimes = json['regularTimes'];
    return DailyReminderLists(
      challengeModeTimes: jsonChallengeModeTimes.map((jsonChallengeModeTime){
        Timestamp challengeModeTime = jsonChallengeModeTime;
        return challengeModeTime;
      }).toList(),
      regularTimes: jsonRegularTimes.map((jsonRegularTime){
        Timestamp regularTime = jsonRegularTime;
        return regularTime;
      }).toList(),
    );
  }
  Map<String, dynamic> toJson(){
    return {
      "challengeModeTimes": challengeModeTimes,
      "regularTimes": regularTimes,
    };
  }
  static bool haveChanged(DailyReminderLists newList, DailyReminderLists oldList){
    bool listsHaveChanged = false;
    if(newList != null){
      for(int i = 0; i < oldList.regularTimes.length; i++){
        if(oldList.regularTimes[i] != newList.regularTimes[i]){
          listsHaveChanged = true;
        }
      }
      for(int i = 0; i < oldList.challengeModeTimes.length; i++){
        if(oldList.challengeModeTimes[i] != newList.challengeModeTimes[i]){
          listsHaveChanged = true;
        }
      }
    }
    return listsHaveChanged;
  }
}