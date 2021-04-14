class CustomTechniqueFormModel{
  String title;
  String description;
  int inhaleDuration;
  int firstHoldDuration;
  int exhaleDuration;
  int secondHoldDuration;
  bool isPaidVersionOnly;
  String assetImage;
  List<String> selectedTags;
  int associatedUserID;
  int inhaleTypeID;
  int exhaleTypeID;
  CustomTechniqueFormModel({this.title, this.assetImage, this.isPaidVersionOnly = true,
  this.secondHoldDuration, this.exhaleDuration, this.inhaleDuration, this.firstHoldDuration,
  this.description, this.selectedTags, this.associatedUserID,
  this.exhaleTypeID, this.inhaleTypeID});
  setProperty(property, value){
    if(property == 'inhaleDuration'){
      this.inhaleDuration = value;
    }
    else if(property == 'firstHoldDuration'){
      this.firstHoldDuration = value;
    }
    else if(property == 'exhaleDuration'){
      this.exhaleDuration = value;
    }
    else if(property == 'secondHoldDuration'){
      this.secondHoldDuration = value;
    }
  }
  dynamic getProperty(property){
    if(property == 'inhaleDuration'){
      return this.inhaleDuration;
    }
    else if(property == 'firstHoldDuration'){
      return this.firstHoldDuration;
    }
    else if(property == 'exhaleDuration'){
      return this.exhaleDuration;
    }
    else if(property == 'secondHoldDuration'){
      return this.secondHoldDuration;
    }
  }
  @override
  String toString() {
    return 'Title: ${this.title}, Description: ${this.description}, Asset Image: ${this.assetImage}, Inhale Duration: ${this.inhaleDuration}, First Hold Duration: ${this.firstHoldDuration}, Exhale Duration: ${this.exhaleDuration}, Second Hold Duration: ${this.secondHoldDuration}, Tags: ${this.selectedTags}, Associated User ID: ${this.associatedUserID}, Inhale Type ID: ${this.inhaleTypeID}, Exhale Type ID:, ${this.exhaleTypeID}';
  }
}