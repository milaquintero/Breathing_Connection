import 'package:breathing_connection/models/technique.dart';
import 'package:flutter/cupertino.dart';

class ViewTechniqueDetailsHandler extends ChangeNotifier{
  Technique techniqueBeingViewed;
  ViewTechniqueDetailsHandler({this.techniqueBeingViewed});
  setTechnique(Technique selectedTechnique){
    this.techniqueBeingViewed = selectedTechnique;
    notifyListeners();
  }
}