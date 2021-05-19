import 'package:breathing_connection/models/app_theme.dart';
import 'package:flutter/cupertino.dart';

class CurrentThemeHandler extends ChangeNotifier{
  AppTheme currentTheme;
  CurrentThemeHandler({this.currentTheme});
  setCurrentTheme(AppTheme selectedTheme){
    this.currentTheme = selectedTheme;
    notifyListeners();
  }
}