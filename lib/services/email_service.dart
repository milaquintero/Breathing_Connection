import 'package:breathing_connection/models/email_form_model.dart';
import 'package:breathing_connection/models/email_list_entry.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmailService{
  String _uid;
  static final EmailService _emailService = EmailService._internal();
  factory EmailService(uid){
    _emailService._uid = uid;
    return _emailService;
  }
  EmailService._internal();

  CollectionReference _emailListCollection = Firestore.instance.collection("email-list");

  EmailListEntry _emailListEntryFromSnapshot(DocumentSnapshot snapshot){
    Iterable emailSubscriptionTypes = snapshot.data != null ? snapshot.data['emailSubscriptionTypes'] : [];
    return snapshot.data != null ? EmailListEntry(
      username: snapshot.data['username'],
      email: snapshot.data['email'],
      birthday: snapshot.data['birthday'],
      emailSubscriptionTypes: emailSubscriptionTypes.map((emailSubscriptionType) => emailSubscriptionType.toString()).toList()
    ) : EmailListEntry();
  }

  Future<EmailListEntry> getEmailListEntry(){
    return _emailService._emailListCollection
        .document(_uid).snapshots().map(_emailListEntryFromSnapshot).first;
  }

  Future<bool> addToEmailList(EmailFormModel emailFormModel) async{
    try{
      await _emailService._emailListCollection
          .document(_emailService._uid).setData({
        "username": emailFormModel.username,
        "email": emailFormModel.email,
        "birthday": emailFormModel.birthday,
        "emailSubscriptionTypes": emailFormModel.emailSubscriptionTypes
      }, merge: true);
      await UserService().addToEmailList(_emailService._uid, emailFormModel.emailSubscriptionTypes.length != 0);
      return true;
    }
    catch(error){
      print(error.toString());
      return false;
    }
  }
}