import 'dart:math';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'models/user.dart';

class Utility{
  static Color toColor(String color){
    String formattedColor = color.substring(2);
    return Color(int.parse(formattedColor, radix: 16));
  }
  static bool userJustRegistered = false;
  //track if in app purchase API is available for device
  static bool iapIsAvailable = true;
  //track max alarm id to be able to cancel them if daily reminder times change
  static List<int> alarmIDs = [];
  static void cancelAllAlarms(){
    for(int i = 0; i < alarmIDs.length; i++){
      AndroidAlarmManager.cancel(alarmIDs[i]);
    }
    alarmIDs = [];
  }
  static void scheduleDailyReminders(User curUser, MainData mainData){
    //initially cancel all alarms
    cancelAllAlarms();
    // Ensure we have a unique alarm ID.
    int newAlarmID = Random().nextInt(pow(2, 31).toInt());
    if(curUser.userSettings.dailyReminders){
      //set alarms for regular times (AM/PM)
      for(Timestamp regularTimestamp in curUser.dailyReminderLists.regularTimes){
        DateTime regularTime = regularTimestamp.toDate();
        BreathingConnection.setNotificationText(
            header: mainData.dailyReminderHeader,
            footer: mainData.dailyReminderFooter
        );
        setReminder(
            alarmId: newAlarmID,
            timeToStart: regularTime
        );
        Utility.alarmIDs.add(newAlarmID);
      }
    }
    if(curUser.hasFullAccess && curUser.userSettings.challengeMode){
      //set alarms for challenge mode (three times a day)
      for(Timestamp challengeModeTimestamp in curUser.dailyReminderLists.challengeModeTimes){
        DateTime challengeModeTime = challengeModeTimestamp.toDate();
        BreathingConnection.setNotificationText(
            header: mainData.challengeReminderHeader,
            footer: mainData.challengeReminderFooter
        );
        setReminder(
            alarmId: newAlarmID,
            timeToStart: challengeModeTime
        );
        Utility.alarmIDs.add(newAlarmID);
      }
    }
  }
  //set a reminder
  static void setReminder({int alarmId, DateTime timeToStart}) async{
    DateTime now = DateTime.now();
    DateTime paramTimeToStart = new DateTime(
        now.year,
        now.month,
        now.day,
        timeToStart.hour,
        timeToStart.minute);
    //schedule tomorrow if alarm time is in the past
    if(now.millisecondsSinceEpoch > paramTimeToStart.millisecondsSinceEpoch){
      paramTimeToStart = new DateTime(
          now.year,
          now.month,
          now.day + 1,
          timeToStart.hour,
          timeToStart.minute);
    }
    await AndroidAlarmManager.periodic(
        Duration(days: 1),
        alarmId,
        BreathingConnection.showNotification,
        startAt: paramTimeToStart,
        exact: false,
        wakeup: true,
        rescheduleOnReboot: true
    );
  }
}