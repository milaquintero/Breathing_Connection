import 'package:breathing_connection/models/main_data.dart';
import 'package:http/http.dart';
import 'dart:convert';

import '../constants.dart';

class MainDataService{
  static Future<MainData> mainData() async{
    try{
      //PROD
      //Response response = await get('$BASE_URL/techniques');
      //TEST
      Response response = await Future.delayed(Duration(seconds: 1), (){
        return Response('{"pages":[{"pageIndex":0,"pageTitle":"Home","pageRoute":"/home"},{"pageIndex":1,"pageTitle":"Technique List","pageRoute":"/technique-list"},{"pageIndex":2,"pageTitle":"App Settings","pageRoute":"/settings"},{"pageIndex":3,"pageTitle":"Pro License","pageRoute":"/pro"}],"images":["assets/day.jpg","assets/night.jpg","assets/custom.jpg","assets/emergency.jpg","assets/challenge.jpg"],"inhaleExhaleTypes":[{"id":1,"description":"Nose"},{"id":2,"description":"Mouth"},{"id":3,"description":"Lips"},{"id":4,"description":"Force Abdomen"}],"popupWaitTime":30,"appBarHeight":72.0,"themes":[{"themeID":1,"themeName":"Primary","brandPrimaryColor":"0xFF01579B","brandSecondaryColor":"0xFF00838F","brandAccentColor":"0xFF303030","bgPrimaryColor":"0xFFFFFFFF","bgSecondaryColor":"0xFFE0F7FA","bgAccentColor":"0xFF78909C","textPrimaryColor":"0xFFFFFFFF","textSecondaryColor":"0xFF01579B","textAccentColor":"0xFF000000","decorationPrimaryColor":"0xFF9E9E9E","decorationSecondaryColor":"0xFF90CAF9","errorColor":"0xFFF44336","amTechniqueSectionColor":"0xFF01579B","amTechniqueTextColor":"0xFFFFFFFF","pmTechniqueSectionColor":"0xFFC51162","pmTechniqueTextColor":"0xFFFFFFFF","emergencyTechniqueSectionColor":"0xFFD32F2F","emergencyTechniqueTextColor":"0xFFFFFFFF","challengeTechniqueSectionColor":"0xFF00838F","challengeTechniqueTextColor":"0xFFFFFFFF","customTechniqueSectionColor":"0xFFFF3D00","customTechniqueTextColor":"0xFFFFFFFF","bulletListIconColor":"0xFF4DD0E1","disabledCardBgColor":"0xFF78909C","disabledCardBgAccentColor":"0xFF90A4AE","disabledCardTextColor":"0xFFBDBDBD","disabledCardBorderColor":"0xFF90A4AE","cardBorderColor":"0xFFE0E0E0","cardTitleColor":"0xFF263238","cardSubtitleColor":"0xFF757575","cardBgColor":"0xFFFFFFFF","cardActionColor":"0xFF1565C0","bottomNavBgColor":"0xFFEEEEEE"},{"themeID":2,"themeName":"Dark","brandPrimaryColor":"0xFF304A7D","brandSecondaryColor":"0xFF00838F","brandAccentColor":"0xFF607D8B","bgPrimaryColor":"0xFF1D2C4C","bgSecondaryColor":"0xFF1D2C4C","bgAccentColor":"0xFF78909C","textPrimaryColor":"0xFFFFFFFF","textSecondaryColor":"0xFFFFFFFF","textAccentColor":"0xFFE0F2F1","decorationPrimaryColor":"0xFF607D8B","decorationSecondaryColor":"0xFF00838F","errorColor":"0xFFF44336","amTechniqueSectionColor":"0xFF01579B","amTechniqueTextColor":"0xFFFFFFFF","pmTechniqueSectionColor":"0xFFC51162","pmTechniqueTextColor":"0xFFFFFFFF","emergencyTechniqueSectionColor":"0xFFD32F2F","emergencyTechniqueTextColor":"0xFFFFFFFF","challengeTechniqueSectionColor":"0xFF00838F","challengeTechniqueTextColor":"0xFFFFFFFF","customTechniqueSectionColor":"0xFFFF3D00","customTechniqueTextColor":"0xFFFFFFFF","bulletListIconColor":"0xFF4DD0E1","disabledCardBgColor":"0xFF78909C","disabledCardBgAccentColor":"0xFF90A4AE","disabledCardTextColor":"0xFFBDBDBD","disabledCardBorderColor":"0xFF90A4AE","cardBorderColor":"0xFF00838F","cardTitleColor":"0xFFFFFFFF","cardSubtitleColor":"0xFFFFFFFF","cardBgColor":"0xFF1D2C4C","cardActionColor":"0xFFFFFFFF","bottomNavBgColor":"0xFF304A7D"}]}', 200);
      });
      return MainData.fromJson(jsonDecode(response.body));
    }
    catch(error){
      throw new Exception(error);
    }
  }
}