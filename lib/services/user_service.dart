import 'dart:convert';
import 'package:breathing_connection/constants.dart';
import 'package:http/http.dart';
import 'package:breathing_connection/models/user.dart';
//shareable user resource with GET method to retrieve user data
class UserService {
  static User curUser;
  //get user data from backend
  static Future<User> userData() async{
    Response userResponse = await get('$BASE_URL/users/1');
    return User.fromJson(jsonDecode(userResponse.body));
  }
}