class DailyReminderLists{
  List<DateTime> challengeModeTimes;
  List<DateTime> regularTimes;
  DailyReminderLists({this.challengeModeTimes, this.regularTimes});
  factory DailyReminderLists.fromJson(Map<String, dynamic> json){
    Iterable jsonChallengeModeTimes = json['challengeModeTimes'];
    Iterable jsonRegularTimes = json['regularTimes'];
    return DailyReminderLists(
      challengeModeTimes: jsonChallengeModeTimes.map((jsonChallengeModeTime) => DateTime.tryParse(jsonChallengeModeTime)).toList(),
      regularTimes: jsonRegularTimes.map((jsonRegularTime) => DateTime.tryParse(jsonRegularTime)).toList(),
    );
  }
}