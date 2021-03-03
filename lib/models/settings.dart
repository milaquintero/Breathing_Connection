class Settings{
  bool breathingSound;
  bool backgroundSound;
  bool vibration;
  bool dailyReminders;
  int themeID;
  Settings({this.breathingSound, this.backgroundSound,
    this.vibration, this.dailyReminders, this.themeID});
  factory Settings.fromJson(Map<String, dynamic> json){
    return Settings(
      breathingSound: json['breathingSound'],
      backgroundSound: json['backgroundSound'],
      vibration: json['vibration'],
      dailyReminders: json['dailyReminders'],
      themeID: json['themeID']
    );
  }
}