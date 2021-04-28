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
}