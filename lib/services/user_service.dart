import 'dart:convert';
import 'package:breathing_connection/models/daily_reminder_lists.dart';
import 'package:breathing_connection/models/user_form_model.dart';
import 'package:breathing_connection/models/user_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:breathing_connection/models/user.dart';
//shareable user resource with GET method to retrieve user data
class UserService {
  static final UserService _userService = UserService._internal();
  factory UserService(){
    return _userService;
  }
  UserService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference _userDataCollection = Firestore.instance.collection('user-data');

  //create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(
      userId: user.uid,
      username: user.displayName,
      email: user.email
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
      });
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

  static Future<void> handleCustomTechnique(String op, int customTechniqueID) async{
    try{
      //PROD
      //Response customTechniqueResponse = await get('$BASE_URL/users/$userID');
      //TEST
      if(op == 'add'){
        //TODO: persist adding technique id to user's custom technique list
      }
    }
    catch(error){
      throw new Exception(error);
    }
  }

  static Future<void> handleUpdateSettings(UserSettings newSettings){
    //TODO: persist changes to settings
  }
}