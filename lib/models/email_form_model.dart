import 'package:cloud_firestore/cloud_firestore.dart';

class EmailFormModel{
  String username;
  String email;
  Timestamp birthday;
  List<String> emailSubscriptionTypes;
  EmailFormModel({this.username, this.email, this.birthday, this.emailSubscriptionTypes});
  @override
  String toString() {
    return 'Name: ${this.username}, Email: ${this.email}, Birth Date: ${this.birthday}, Email Subscription Types: ${this.emailSubscriptionTypes}';
  }
}