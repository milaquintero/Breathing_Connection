class Technique{
  int techniqueID;
  String title;
  String description;
  int inhaleDuration;
  int firstHoldDuration;
  int exhaleDuration;
  int secondHoldDuration;
  bool isPaidVersionOnly;
  Technique({this.techniqueID, this.title, this.description, this.isPaidVersionOnly,
    this.inhaleDuration, this.firstHoldDuration,
    this.exhaleDuration, this.secondHoldDuration});
  factory Technique.fromJson(Map<String, dynamic> json){
    return Technique(
      techniqueID: json['id'],
      title: json['title'],
      description: json['description'],
      isPaidVersionOnly: json['isPaidVersionOnly'],
      inhaleDuration: json['inhaleDuration'],
      firstHoldDuration: json['firstHoldDuration'],
      exhaleDuration: json['exhaleDuration'],
      secondHoldDuration: json['secondHoldDuration'],
    );
  }
}