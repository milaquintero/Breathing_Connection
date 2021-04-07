import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/inhale_exhale_type.dart';

import 'nav_link.dart';

class MainData{
  List<NavLink> pages;
  List<String> images;
  List<InhaleExhaleType> inhaleExhaleTypes;
  int popupWaitTime;
  List<AppTheme> themes;
  double appBarHeight;
  MainData({this.pages, this.images, this.inhaleExhaleTypes,
    this.popupWaitTime, this.themes, this.appBarHeight});
  factory MainData.fromJson(Map<String, dynamic> json){
    Iterable jsonPages = json['pages'] ?? [];
    Iterable jsonImages = json['images'] ?? [];
    Iterable jsonInhaleExhaleTypes = json['inhaleExhaleTypes'] ?? [];
    Iterable jsonThemes = json['themes'] ?? [];
    return MainData(
        pages: jsonPages.map((jsonPage) => NavLink.fromJson(jsonPage)).toList(),
        images: jsonImages.map((jsonImage) => jsonImage.toString()).toList(),
        inhaleExhaleTypes: jsonInhaleExhaleTypes.map((jsonInhaleExhaleType) => InhaleExhaleType.fromJson(jsonInhaleExhaleType)).toList(),
        popupWaitTime: json['popupWaitTime'],
        themes: jsonThemes.map((jsonTheme) => AppTheme.fromJson(jsonTheme)).toList(),
        appBarHeight: json['appBarHeight']
    );
  }
  setMainData(MainData mainData){
    this.pages = mainData.pages;
    this.images = mainData.images;
    this.inhaleExhaleTypes = mainData.inhaleExhaleTypes;
    this.popupWaitTime = mainData.popupWaitTime;
    this.themes = mainData.themes;
    this.appBarHeight = mainData.appBarHeight;
  }
}