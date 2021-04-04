import 'package:breathing_connection/models/inhale_exhale_type.dart';

import 'nav_link.dart';

class MainData{
  List<NavLink> pages;
  List<String> images;
  List<InhaleExhaleType> inhaleExhaleTypes;
  int popupWaitTime;
  MainData({this.pages, this.images, this.inhaleExhaleTypes, this.popupWaitTime});
  factory MainData.fromJson(Map<String, dynamic> json){
    Iterable jsonPages = json['pages'] ?? [];
    Iterable jsonImages = json['images'] ?? [];
    Iterable jsonInhaleExhaleTypes = json['inhaleExhaleTypes'] ?? [];
    return MainData(
        pages: jsonPages.map((jsonPage) => NavLink.fromJson(jsonPage)).toList(),
        images: jsonImages.map((jsonImage) => jsonImage.toString()).toList(),
        inhaleExhaleTypes: jsonInhaleExhaleTypes.map((jsonInhaleExhaleType) => InhaleExhaleType.fromJson(jsonInhaleExhaleType)).toList(),
        popupWaitTime: json['popupWaitTime']
    );
  }
  setMainData(MainData mainData){
    this.pages = mainData.pages;
    this.images = mainData.images;
    this.inhaleExhaleTypes = mainData.inhaleExhaleTypes;
    this.popupWaitTime = mainData.popupWaitTime;
  }
}