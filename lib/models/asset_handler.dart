import 'package:breathing_connection/constants.dart';
import 'package:flutter/cupertino.dart';

class AssetHandler extends ChangeNotifier{
  String baseAssetURL;
  String imageAssetURL;
  String videoAssetURL;
  AssetHandler({this.imageAssetURL, this.baseAssetURL, this.videoAssetURL});
  void init(bool userHasFullAccess){
    //set up pro version asset access
    if(userHasFullAccess){
      baseAssetURL = PRO_VERSION_ASSET_URL;
    }
    //set up free version asset access
    else{
      baseAssetURL = FREE_VERSION_ASSET_URL;
    }
    //set image, music and sound asset urls
    imageAssetURL = "$baseAssetURL/$IMAGE_ASSET_DIR";
    videoAssetURL = "$baseAssetURL/$VIDEO_ASSET_DIR";
    notifyListeners();
  }
}