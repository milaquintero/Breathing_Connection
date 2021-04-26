import 'package:breathing_connection/models/main_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainDataService{
  static final MainDataService _mainDataService = MainDataService._internal();
  factory MainDataService(){
    return _mainDataService;
  }
  MainDataService._internal();
  //collection reference
  final CollectionReference _mainDataCollection = Firestore.instance.collection('main-data');
  static Future<MainData> getMainDataRemotely() async{
    try{
      //main data instance to return
      MainData tempMainData = MainData();

      //get main data constants document
      DocumentSnapshot mainDataConstantsSnapshot = await _mainDataService._mainDataCollection
          .document('constants').snapshots().first;

      //set constants data in temp object
      tempMainData = MainData.fromSnapShot(tempMainData, mainDataConstantsSnapshot, 'constants');

      //get main data meta document
      DocumentSnapshot mainDataMetaSnapshot = await _mainDataService._mainDataCollection
          .document('meta').snapshots().first;
      tempMainData = MainData.fromSnapShot(tempMainData, mainDataMetaSnapshot, 'meta');

      //set meta data in temp object

      //get main data assets document
      DocumentSnapshot mainDataAssetsSnapshot = await _mainDataService._mainDataCollection
          .document('assets').snapshots().first;

      //set assets data in temp object
      tempMainData = MainData.fromSnapShot(tempMainData, mainDataAssetsSnapshot, 'assets');

      //get main data colors document
      DocumentSnapshot mainDataColorsSnapshot = await _mainDataService._mainDataCollection
          .document('colors').snapshots().first;
      //set colors data in temp object
      tempMainData = MainData.fromSnapShot(tempMainData, mainDataColorsSnapshot, 'colors');

      return tempMainData;
    }
    catch(error){
      throw new Exception(error);
    }
  }
}