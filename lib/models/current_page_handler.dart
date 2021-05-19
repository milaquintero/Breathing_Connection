import 'package:flutter/cupertino.dart';

class CurrentPageHandler extends ChangeNotifier{
  int pageIndex;
  CurrentPageHandler({this.pageIndex});
  setPageIndex(int index){
    this.pageIndex = index;
    notifyListeners();
  }
}