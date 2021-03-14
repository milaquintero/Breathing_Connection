import 'package:flutter/cupertino.dart';

class CurrentPageHandler extends ChangeNotifier{
  int pageIndex;
  String pageRoute;
  CurrentPageHandler({this.pageIndex, this.pageRoute});
  setPage(CurrentPageHandler page){
    this.pageIndex = page.pageIndex;
    this.pageRoute = page.pageRoute;
    notifyListeners();
  }
}