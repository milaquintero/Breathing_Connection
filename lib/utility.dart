import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
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
  static int maxAlarmId = 0;
  static void cancelAllAlarms(){
    for(int i = 0; i < maxAlarmId; i++){
      AndroidAlarmManager.cancel(i);
    }
    maxAlarmId = 0;
  }
  static void scheduleDailyReminders(User curUser, MainData mainData){
    if(curUser.userSettings.dailyReminders){
      //set alarms for regular times (AM/PM)
      for(Timestamp regularTimestamp in curUser.dailyReminderLists.regularTimes){
        DateTime now = DateTime.now();
        DateTime regularTime = regularTimestamp.toDate();
        BreathingConnection.setNotificationText(
            header: mainData.dailyReminderHeader,
            footer: mainData.dailyReminderFooter
        );
        setReminder(
            alarmId: Utility.maxAlarmId,
            timeToStart: DateTime(
                now.year,
                now.month,
                now.day,
                regularTime.hour,
                regularTime.minute),
            callback: BreathingConnection.showNotification
        );
        Utility.maxAlarmId++;
      }
    }
    if(curUser.hasFullAccess && curUser.userSettings.challengeMode){
      //set alarms for challenge mode (three times a day)
      for(Timestamp challengeModeTimestamp in curUser.dailyReminderLists.challengeModeTimes){
        DateTime now = DateTime.now();
        DateTime challengeModeTime = challengeModeTimestamp.toDate();
        BreathingConnection.setNotificationText(
            header: mainData.challengeReminderHeader,
            footer: mainData.challengeReminderFooter
        );
        setReminder(
            alarmId: Utility.maxAlarmId,
            timeToStart: DateTime(
                now.year,
                now.month,
                now.day,
                challengeModeTime.hour,
                challengeModeTime.minute),
            callback: BreathingConnection.showNotification
        );
        Utility.maxAlarmId++;
      }
    }
  }
  //set a reminder
  static void setReminder({int alarmId, Function callback, DateTime timeToStart}) async{
    await AndroidAlarmManager.periodic(
      //repeat every 24 hours in case user doesn't quit the app
        Duration(hours: 24),
        alarmId,
        callback,
        startAt: timeToStart,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: false
    );
  }
}