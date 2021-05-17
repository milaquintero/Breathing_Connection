import 'package:breathing_connection/utility.dart';
import 'package:breathing_connection/models/daily_reminder_lists.dart';
import 'package:breathing_connection/models/user_form_model.dart';
import 'package:breathing_connection/models/user_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:breathing_connection/models/user.dart';
//shareable user resource with GET method to retrieve user data
class UserService {
  static final UserService _userService = UserService._internal();

  String uid;

  factory UserService({String uid}){
    _userService.uid = uid;
    return _userService;
  }
  UserService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference _userDataCollection = Firestore.instance.collection('user-data');

  //create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(
      userId: user.uid,
      email: user.email,
      isEmailVerified: user.isEmailVerified,
    ) : null;
  }

  //auth change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  Stream<User> get userWithData async*{
    FirebaseUser firebaseUser = await _auth.currentUser();
    yield* _userService._userDataCollection.document(firebaseUser.uid)
        .snapshots().map((snapshot){
          return User.fromJson(snapshot.data);
    });
  }

  //sign in with email + password
  Future signInWithEmailAndPassword(UserFormModel userFormModel) async{
    try{
      final AuthResult result = await _auth.signInWithEmailAndPassword(
          email: userFormModel.email,
          password: userFormModel.password
      );
      FirebaseUser firebaseUser = result.user;
      //get user data from firebase collection based on uid
      DocumentSnapshot userDataSnapshot = await _userService._userDataCollection
          .document(firebaseUser.uid).snapshots().first;
      User curUser = User.fromJson(userDataSnapshot.data);

      //if user verified email but database isn't up to date then update in database
      if(!curUser.isEmailVerified && firebaseUser.isEmailVerified){
        _userService._userDataCollection.document(curUser.userId)
            .setData({
          "isEmailVerified": true
        }, merge: true);
      }

      return curUser;
    }
    catch(error){
      print(error.toString());
      return null;
    }
  }

  //register with email + password
  Future registerWithEmailAndPassword(UserFormModel userFormModel) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: userFormModel.email,
          password: userFormModel.password
      );
      FirebaseUser firebaseUser = result.user;
      User curUser = _userFromFirebaseUser(firebaseUser);
      //set username from form
      curUser.username = userFormModel.username;
      //defaults for user
      curUser.hasFullAccess = false;
      DateTime now = DateTime.now();
      curUser.dailyReminderLists = DailyReminderLists(
        challengeModeTimes: [
          Timestamp.fromDate(DateTime(
              now.year,
              now.month,
              now.day,
              8,
              0)),
          Timestamp.fromDate(DateTime(
              now.year,
              now.month,
              now.day,
              12,
              0)),
          Timestamp.fromDate(DateTime(
              now.year,
              now.month,
              now.day,
              16,
              0))
        ],
        regularTimes: [
          Timestamp.fromDate(DateTime(
              now.year,
              now.month,
              now.day,
              8,
              0)),
          Timestamp.fromDate(DateTime(
              now.year,
              now.month,
              now.day,
              16,
              0))
        ]
      );
      curUser.isSubscribedToEmails = false;
      curUser.amTechniqueID = 1;
      curUser.pmTechniqueID = 2;
      curUser.emergencyTechniqueID = 3;
      curUser.challengeTechniqueID = 4;
      curUser.customTechniqueIDs = [];
      //defaults for user settings
      UserSettings userSettings = UserSettings(
        breathingSound: true,
        backgroundSound: true,
        vibration: true,
        dailyReminders: true,
        themeID: 1,
        challengeMode: false
      );
      curUser.userSettings = userSettings;
      //create a new document for the user based on uid
      await _userDataCollection.document(curUser.userId).setData({
        "userId": curUser.userId,
        "username": curUser.username,
        "email": curUser.email,
        "hasFullAccess": curUser.hasFullAccess,
        "isSubscribedToEmails": curUser.isSubscribedToEmails,
        "userSettings": curUser.userSettings.toJson(),
        "amTechniqueID": curUser.amTechniqueID,
        "pmTechniqueID": curUser.pmTechniqueID,
        "challengeTechniqueID": curUser.challengeTechniqueID,
        "emergencyTechniqueID": curUser.emergencyTechniqueID,
        "customTechniqueIDs": curUser.customTechniqueIDs,
        "dailyReminderLists": curUser.dailyReminderLists.toJson(),
        "isEmailVerified": false
      });

      //send user email verification after persisting data
      firebaseUser.sendEmailVerification();

      //set flag for displaying email verification dialog in home page
      Utility.userJustRegistered = true;

      return curUser;
    }
    catch(error){
      print(error.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }
    catch(error){
      print(error.toString());
      return null;
    }
  }

  Future<bool> handleCustomTechnique(List<int> newCustomTechniqueIDs) async{
    try{
      //handle setting updated ids for user's customTechniqueIDs
      _userService._userDataCollection.document(uid)
          .setData({
        "customTechniqueIDs": newCustomTechniqueIDs
      }, merge: true);
      return true;
    }
    catch(error){
      print(error.toString());
      return false;
    }
  }

  Future handleUpdateSettings(UserSettings newSettings) async{
    try{
      await _userService._userDataCollection.document(uid)
          .setData({
        "userSettings": newSettings.toJson()
      }, merge: true);
    }
    catch(error){
      throw new Exception(error);
    }
  }


  Future<bool> handleChangeTechnique(String op, int selectedTechniqueID) async{
    String changedTechniqueType;
    if(op == 'Morning'){
      changedTechniqueType = "amTechniqueID";
    }
    else if(op == 'Evening'){
      changedTechniqueType = "pmTechniqueID";
    }
    else if(op == 'Emergency'){
      changedTechniqueType = "emergencyTechniqueID";
    }
    else if(op == 'Challenge'){
      changedTechniqueType = "challengeTechniqueID";
    }

    try{
      _userService._userDataCollection.document(uid)
          .setData({
        changedTechniqueType: selectedTechniqueID
      }, merge: true);
      return true;
    }
    catch(error){
      return false;
    }
  }

  Future<bool> addToEmailList(bool isSubscribedToEmails) async{
    try{
      _userService._userDataCollection
        .document(uid).setData({
        "isSubscribedToEmails": isSubscribedToEmails
      }, merge: true);
      return true;
    }
    catch(error){
      print(error.toString());
      return false;
    }
  }

  Future handleUpdateDailyReminderLists(DailyReminderLists newDailyReminderLists) async{
    try{
      await _userService._userDataCollection.document(uid)
          .setData({
        "dailyReminderLists": newDailyReminderLists.toJson()
      }, merge: true);
    }
    catch(error){
      throw new Exception(error);
    }
  }

  Future<bool> updateAccountType(String op) async{
    try{
      await _userService._userDataCollection.document(uid)
          .setData({
        "hasFullAccess": op == 'pro' ? true : false
      }, merge: true);
      return true;
    }
    catch(error){
      print(error.toString());
      return false;
    }
  }

  Future<bool> isEmailVerified() async{
    try{
      FirebaseUser firebaseUser = await _auth.currentUser();
      return firebaseUser.isEmailVerified;
    }
    catch(error){
      print(error.toString());
      return false;
    }
  }

  Future resendConfirmationEmail() async{
    try{
      FirebaseUser firebaseUser = await _auth.currentUser();
      firebaseUser.sendEmailVerification();
    }
    catch(error){
      print(error.toString());
    }
  }
}