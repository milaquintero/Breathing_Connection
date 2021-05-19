import 'package:breathing_connection/models/main_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class MainDataService{
  static final MainDataService _mainDataService = MainDataService._internal();
  factory MainDataService(){
    return _mainDataService;
  }
  MainDataService._internal();
  //collection reference
  final CollectionReference _mainDataCollection = Firestore.instance.collection('main-data');
  Stream<MainData> get mainData async*{
    try{
      //get main data constants document
      Stream<DocumentSnapshot> mainDataConstantsStream = _mainDataService._mainDataCollection
          .document('constants').snapshots();
      //get main data meta document
      Stream<DocumentSnapshot> mainDataMetaStream = _mainDataService._mainDataCollection
          .document('meta').snapshots();
      //get main data assets document
      Stream<DocumentSnapshot> mainDataAssetsStream = _mainDataService._mainDataCollection
          .document('assets').snapshots();
      //get main data colors document
      Stream<DocumentSnapshot> mainDataColorsStream = _mainDataService._mainDataCollection
          .document('colors').snapshots();
      //return merged streams
      yield* CombineLatestStream([
        mainDataConstantsStream,
        mainDataMetaStream,
        mainDataAssetsStream,
        mainDataColorsStream
      ], ((List<DocumentSnapshot> snapshotArray) {
        MainData tempMainData = MainData();
        tempMainData = MainData.fromSnapShot(tempMainData, snapshotArray[0], 'constants');
        tempMainData = MainData.fromSnapShot(tempMainData, snapshotArray[1], 'meta');
        tempMainData = MainData.fromSnapShot(tempMainData, snapshotArray[2], 'assets');
        tempMainData = MainData.fromSnapShot(tempMainData, snapshotArray[3], 'colors');
        return tempMainData;
      }));
    }
    catch(error){
      throw new Exception(error);
    }
  }
}