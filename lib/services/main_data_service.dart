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
        return Response('{"pages":[{"pageIndex":0,"pageTitle":"Home","pageRoute":"/home"},{"pageIndex":1,"pageTitle":"Technique List","pageRoute":"/technique-list"},{"pageIndex":2,"pageTitle":"App Settings","pageRoute":"/settings"},{"pageIndex":3,"pageTitle":"Pro License","pageRoute":"/pro"},{"pageIndex":4,"pageTitle":"Newsletter","pageRoute":"/email-subscription"}]}', 200);
      });
      return MainData.fromJson(jsonDecode(response.body));
    }
    catch(error){
      throw new Exception(error);
    }
  }
}