import 'package:breathing_connection/models/technique.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TechniqueService{
  static final TechniqueService _techniqueService = TechniqueService._internal();
  factory TechniqueService(){
    return _techniqueService;
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
    return _techniqueService._techniqueListCollection
        .snapshots().map(_techniqueFromSnapshot);
  }

  Future<Technique> handleCustomTechnique(String curUserID, String op, Technique selectedTechnique) async{
    try{
      if(op == 'add'){
        List<Technique> techniqueListSnapshot = await techniqueList.first;
        //sort by technique id
        techniqueListSnapshot.sort((a, b){
          return a.techniqueID.compareTo(b.techniqueID);
        });
        int maxTechniqueListID = techniqueListSnapshot.last.techniqueID;
        selectedTechnique.techniqueID = (maxTechniqueListID + 1);
        await _techniqueService._techniqueListCollection.add({
          "isPaidVersionOnly": true,
          "techniqueID": selectedTechnique.techniqueID,
          "title": selectedTechnique.title,
          "tags": selectedTechnique.tags,
          "description": selectedTechnique.description,
          "inhaleDuration": selectedTechnique.inhaleDuration,
          "firstHoldDuration": selectedTechnique.firstHoldDuration,
          "exhaleDuration": selectedTechnique.exhaleDuration,
          "secondHoldDuration": selectedTechnique.secondHoldDuration,
          "assetImage": selectedTechnique.assetImage,
          "inhaleTypeID": selectedTechnique.inhaleTypeID,
          "exhaleTypeID": selectedTechnique.exhaleTypeID,
          "categoryAvailabilities": ["PM", "AM", "Emergency", "Challenge"],
          "associatedUserID": curUserID
        });
        return selectedTechnique;
      }
      else if(op == 'remove'){
        //TODO: implement removing custom technique from technique-list collection
        return null;
      }
      else{
        return null;
      }
    }
    catch(error){
      throw new Exception(error);
    }
  }
  
  Future<bool> deleteCustomTechnique(int techniqueIdToDelete) async{
    try{
      //query to get technique by id
      QuerySnapshot techniqueToDeleteQuery = await _techniqueService._techniqueListCollection.where("techniqueID", isEqualTo: techniqueIdToDelete)
          .getDocuments();

      //store document to be able to delete
      DocumentSnapshot techniqueToDeleteDoc = techniqueToDeleteQuery.documents.first;

      //delete document from backend
      await _techniqueService._techniqueListCollection.document(techniqueToDeleteDoc.documentID)
        .delete();

      return true;
    }
    catch(error){
      throw new Exception(error);
      return false;
    }
  }
}