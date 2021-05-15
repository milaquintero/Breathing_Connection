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
  String associatedUserID;
  double minSessionDurationInMinutes;
  String associatedVideo;
  Technique({this.techniqueID, this.title, this.description, this.isPaidVersionOnly,
    this.inhaleDuration, this.firstHoldDuration,
    this.exhaleDuration, this.secondHoldDuration, this.assetImage,
    this.exhaleTypeID, this.inhaleTypeID, this.tags, this.categoryDependencies,
    this.associatedUserID, this.minSessionDurationInMinutes, this.associatedVideo});
  factory Technique.fromSnapshot(json){
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
      associatedUserID: json['associatedUserID'],
      tags: jsonTags.map((jsonTag) => jsonTag.toString()).toList(),
      categoryDependencies: jsonCategoryDependencies.map((jsonCategory) => jsonCategory.toString()).toList(),
      minSessionDurationInMinutes: double.parse(json['minSessionDurationInMinutes'].toString() ?? "0.0"),
      associatedVideo: json['associatedVideo']
    );
  }
  factory Technique.clone(Technique immutableTechnique){
    return Technique(
        title: immutableTechnique?.title ?? '',
        techniqueID: immutableTechnique?.techniqueID ?? 1,
        description: immutableTechnique?.description ?? '',
        isPaidVersionOnly: immutableTechnique?.isPaidVersionOnly ?? false,
        firstHoldDuration: immutableTechnique?.firstHoldDuration ?? 1,
        inhaleDuration: immutableTechnique?.inhaleDuration ?? 1,
        secondHoldDuration: immutableTechnique?.secondHoldDuration ?? 1,
        exhaleDuration: immutableTechnique?.exhaleDuration ?? 1,
        assetImage: immutableTechnique?.assetImage ?? '',
        inhaleTypeID: immutableTechnique?.inhaleTypeID ?? 1,
        exhaleTypeID: immutableTechnique?.exhaleTypeID ?? 1,
        tags: immutableTechnique?.tags ?? [],
        categoryDependencies: immutableTechnique?.categoryDependencies ?? [],
        associatedUserID: immutableTechnique?.associatedUserID ?? null,
        minSessionDurationInMinutes: immutableTechnique?.minSessionDurationInMinutes ?? 5,
        associatedVideo: immutableTechnique?.associatedVideo ?? ''
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
    techniqueMap['associatedUserID'] = selectedTechnique.associatedUserID;
    techniqueMap['minSessionDurationInMinutes'] = selectedTechnique.minSessionDurationInMinutes;
    techniqueMap['associatedVideo'] = selectedTechnique.associatedVideo;
    return techniqueMap;
  }

  @override
  String toString() {
    return 'ID: ${this.techniqueID}, Title: ${this.title}, Description: ${this.description}, Inhale: ${this.inhaleDuration}, Inhale Type ID: ${this.inhaleTypeID}, First Hold: ${this.firstHoldDuration}, Exhale: ${this.exhaleDuration}, Exhale Type ID: ${this.exhaleTypeID}, Second Hold: ${this.secondHoldDuration}, Image: ${this.assetImage}';
  }
}