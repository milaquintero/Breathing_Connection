import 'package:breathing_connection/models/technique.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TechniqueService{
  static final TechniqueService _techniqueService = TechniqueService._internal();

  String _uid;

  factory TechniqueService({String uid}){
    _techniqueService._uid = uid;
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

  Future<Technique> handleCustomTechnique(String op, Technique selectedTechnique) async{
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
          "associatedUserID": _uid,
          "associatedVideo": selectedTechnique.associatedVideo,
          "minSessionDurationInMinutes": selectedTechnique.minSessionDurationInMinutes
        });
        return selectedTechnique;
      }
      else if(op == 'remove'){
        //query to get technique by id
        QuerySnapshot techniqueToDeleteQuery = await _techniqueService._techniqueListCollection.where("techniqueID", isEqualTo: selectedTechnique.techniqueID)
            .getDocuments();

        //store document to be able to delete
        DocumentSnapshot techniqueToDeleteDoc = techniqueToDeleteQuery.documents.first;

        //delete document from backend
        await _techniqueService._techniqueListCollection.document(techniqueToDeleteDoc.documentID)
            .delete();

        return selectedTechnique;
      }
      else if(op == 'edit'){
        //query to get technique by id
        QuerySnapshot techniqueToEditQuery = await _techniqueService._techniqueListCollection.where("techniqueID", isEqualTo: selectedTechnique.techniqueID)
            .getDocuments();

        //store document to be able to delete
        DocumentSnapshot techniqueToEditDoc = techniqueToEditQuery.documents.first;

        //update document from backend
        await _techniqueService._techniqueListCollection.document(techniqueToEditDoc.documentID)
            .setData({
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
          "minSessionDurationInMinutes": selectedTechnique.minSessionDurationInMinutes
        }, merge: true);
        return selectedTechnique;
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