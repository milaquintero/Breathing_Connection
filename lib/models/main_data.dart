import 'nav_link.dart';

class MainData{
  List<NavLink> pages;
  List<String> images;
  MainData({this.pages, this.images});
  factory MainData.fromJson(Map<String, dynamic> json){
    Iterable jsonPages = json['pages'];
    Iterable jsonImages = json['images'];
    return MainData(
        pages: jsonPages.map((jsonPage) => NavLink.fromJson(jsonPage)).toList(),
        images: jsonImages.map((jsonImage) => jsonImage.toString()).toList()
    );
  }
  setMainData(MainData mainData){
    this.pages = mainData.pages;
    this.images = mainData.images;
  }
}