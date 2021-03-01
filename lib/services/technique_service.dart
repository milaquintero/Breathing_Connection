import 'package:breathing_connection/models/technique.dart';
import 'package:http/http.dart';
import 'dart:convert';

import '../constants.dart';

class TechniqueService{
  static List<Technique> techniques;
  static Future<List<Technique>> techniqueData() async{
    Response response = await get('$BASE_URL/techniques');
    Iterable data = jsonDecode(response.body);
    return data.map((technique) => Technique.fromJson(technique)).toList();
  }
}