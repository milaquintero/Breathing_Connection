import 'package:breathing_connection/models/inhale_exhale_type.dart';

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
  int inhaleTypeID;
  int exhaleTypeID;
  List<String> tags;
  List<String> categoryDependencies;
  Technique({this.techniqueID, this.title, this.description, this.isPaidVersionOnly,
    this.inhaleDuration, this.firstHoldDuration,
    this.exhaleDuration, this.secondHoldDuration, this.assetImage,
    this.exhaleTypeID, this.inhaleTypeID, this.tags, this.categoryDependencies});
  factory Technique.fromJson(Map<String, dynamic> json){
    Iterable jsonTags = json['tags'] ?? [];
    Iterable jsonCategoryDependencies = json['categoryAvailabilities'] ?? [];
    return Technique(
      techniqueID: json['techniqueID'],
      title: json['title'],
      description: json['description'],
      isPaidVersionOnly: json['isPaidVersionOnly'],
      inhaleDuration: json['inhaleDuration'],
      firstHoldDuration: json['firstHoldDuration'],
      exhaleDuration: json['exhaleDuration'],
      secondHoldDuration: json['secondHoldDuration'],
      assetImage: json['assetImage'],
      inhaleTypeID: json['inhaleTypeID'],
      exhaleTypeID: json['exhaleTypeID'],
      tags: jsonTags.map((jsonTag) => jsonTag.toString()).toList(),
      categoryDependencies: jsonCategoryDependencies.map((jsonCategory) => jsonCategory.toString()).toList()
    );
  }
  factory Technique.clone(Technique immutableTechnique){
    return Technique(
        title: immutableTechnique.title,
        techniqueID: immutableTechnique.techniqueID,
        description: immutableTechnique.description,
        isPaidVersionOnly: immutableTechnique.isPaidVersionOnly,
        firstHoldDuration: immutableTechnique.firstHoldDuration,
        inhaleDuration: immutableTechnique.inhaleDuration,
        secondHoldDuration: immutableTechnique.secondHoldDuration,
        exhaleDuration: immutableTechnique.exhaleDuration,
        assetImage: immutableTechnique.assetImage,
        inhaleTypeID: immutableTechnique.inhaleTypeID,
        exhaleTypeID: immutableTechnique.exhaleTypeID,
        tags: immutableTechnique.tags,
        categoryDependencies: immutableTechnique.categoryDependencies
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
    techniqueMap['exhaleType'] = selectedTechnique.exhaleTypeID;
    techniqueMap['inhaleType'] = selectedTechnique.inhaleTypeID;
    techniqueMap['tags'] = selectedTechnique.tags;
    techniqueMap['categoryDependencies'] = selectedTechnique.categoryDependencies;
    return techniqueMap;
  }

  @override
  String toString() {
    return 'ID: ${this.techniqueID}, Title: ${this.title}, Description: ${this.description}, Inhale: ${this.inhaleDuration}, First Hold: ${this.firstHoldDuration}, Exhale: ${this.exhaleDuration}, Second Hold: ${this.secondHoldDuration}, Image: ${this.assetImage}';
  }
}