import 'nav_link.dart';

class MainData{
  List<NavLink> pages;
  MainData({this.pages});
  factory MainData.fromJson(Map<String, dynamic> json){
    Iterable jsonPages = json['pages'];
    return MainData(
        pages: jsonPages.map((jsonPage) => NavLink.fromJson(jsonPage)).toList(),
    );
  }
  setMainData(MainData mainData){
    this.pages = mainData.pages;
  }
}