import 'package:cloud_firestore/cloud_firestore.dart';

class EmailListEntry{
  String username;
  String email;
  Timestamp birthday;
  List<String> emailSubscriptionTypes;
  EmailListEntry({this.username, this.email, this.birthday, this.emailSubscriptionTypes});
}