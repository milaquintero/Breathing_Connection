import 'dart:ui';

class Utility{
  static Color toColor(String color){
    String formattedColor = color.substring(2);
    return Color(int.parse(formattedColor, radix: 16));
  }
}