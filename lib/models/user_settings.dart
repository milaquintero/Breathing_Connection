class UserSettings{
  bool breathingSound;
  bool backgroundSound;
  bool vibration;
  bool dailyReminders;
  int themeID;
  UserSettings({this.breathingSound, this.backgroundSound,
    this.vibration, this.dailyReminders, this.themeID});
  factory UserSettings.fromJson(Map<String, dynamic> json){
    return UserSettings(
      breathingSound: json['breathingSound'],
      backgroundSound: json['backgroundSound'],
      vibration: json['vibration'],
      dailyReminders: json['dailyReminders'],
      themeID: json['themeID']
    );
  }
  Map<String, dynamic> toJson(){
    return {
      "breathingSound": breathingSound,
      "backgroundSound": backgroundSound,
      "vibration": vibration,
      "dailyReminders": dailyReminders,
      "themeID": themeID,
    };
  }
  setProperty(String property, dynamic value){
    switch(property){
      case "breathingSound":
        breathingSound = value;
        break;
      case "backgroundSound":
        backgroundSound = value;
        break;
      case "vibration":
        vibration = value;
        break;
      case "dailyReminders":
        dailyReminders = value;
        break;
      case "themeID":
        themeID = value;
        break;
    }
  }
}