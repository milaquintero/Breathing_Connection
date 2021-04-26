import 'package:breathing_connection/models/technique.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TechniqueService{
  static final TechniqueService _mainDataService = TechniqueService._internal();
  factory TechniqueService(){
    return _mainDataService;
  }
  TechniqueService._internal();
  CollectionReference _techniqueListCollection = Firestore.instance.collection('technique-list');

  List<Technique> _techniqueFromSnapshot(QuerySnapshot snapshot){
    Iterable techniqueList = snapshot.documents;
    return techniqueList.map((technique){
      return Technique.fromSnapshot(technique);
    }).toList();
  }

  Stream<List<Technique>> get techniqueList{
    return _mainDataService._techniqueListCollection
        .snapshots().map(_techniqueFromSnapshot);
  }

  static Future<Technique> handleCustomTechnique(String op, Technique selectedTechnique) async{
    try{
      //PROD
      //Response customTechniqueResponse = await get('$BASE_URL/users/$userID');
      //TEST
      if(op == 'add'){
        Technique updatedSelectedTechnique = await Future.delayed(Duration(seconds: 1), (){
          //TODO: persist actual technique
          selectedTechnique.techniqueID = 11;
          return selectedTechnique;
        });
        return updatedSelectedTechnique;
      }
      else{
        return null;
      }
    }
    catch(error){
      throw new Exception(error);
    }
  }
}