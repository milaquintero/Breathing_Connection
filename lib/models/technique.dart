class Technique{
  int techniqueID;
  String title;
  String description;
  int inhaleDuration;
  int firstHoldDuration;
  int exhaleDuration;
  int secondHoldDuration;
  bool isPaidVersionOnly;
  String assetImage;
  Technique({this.techniqueID, this.title, this.description, this.isPaidVersionOnly,
    this.inhaleDuration, this.firstHoldDuration,
    this.exhaleDuration, this.secondHoldDuration, this.assetImage});
  factory Technique.fromJson(Map<String, dynamic> json){
    return Technique(
      techniqueID: json['techniqueID'],
      title: json['title'],
      description: json['description'],
      isPaidVersionOnly: json['isPaidVersionOnly'],
      inhaleDuration: json['inhaleDuration'],
      firstHoldDuration: json['firstHoldDuration'],
      exhaleDuration: json['exhaleDuration'],
      secondHoldDuration: json['secondHoldDuration'],
      assetImage: json['assetImage']
    );
  }
  static Map<String, dynamic> toJson(Technique selectedTechnique){
    Map<String, dynamic> techniqueMap;
    techniqueMap['techniqueID'] = selectedTechnique.techniqueID;
    techniqueMap['title'] = selectedTechnique.title;
    techniqueMap['description'] = selectedTechnique.description;
    techniqueMap['inhaleDuration'] = selectedTechnique.inhaleDuration;
    techniqueMap['firstHoldDuration'] = selectedTechnique.firstHoldDuration;
    techniqueMap['exhaleDuration'] = selectedTechnique.exhaleDuration;
    techniqueMap['secondHoldDuration'] = selectedTechnique.secondHoldDuration;
    techniqueMap['assetImage'] = selectedTechnique.assetImage;
    return techniqueMap;
  }

  @override
  String toString() {
    return 'ID: ${this.techniqueID}, Title: ${this.title}, Description: ${this.description}, Inhale: ${this.inhaleDuration}, First Hold: ${this.firstHoldDuration}, Exhale: ${this.exhaleDuration}, Second Hold: ${this.secondHoldDuration}, Image: ${this.assetImage}';
  }
}