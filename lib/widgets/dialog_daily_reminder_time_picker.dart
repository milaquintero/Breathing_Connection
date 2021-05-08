import 'package:breathing_connection/models/daily_reminder_lists.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class DialogDailyReminderTimePicker extends StatefulWidget {
  final EdgeInsets titlePadding;
  final IconData headerIcon;
  final Function(String, int, Timestamp) cbFunction;
  final Color headerBgColor;
  final Color cardColor;
  final Color textColor;
  final Color dialogBgColor;
  final bool userHasFullAccess;
  final Color buttonColor;
  final Color timeDisplayBgColor;
  final Color timeDisplayTextColor;
  final DailyReminderLists dailyReminderLists;
  final Color timeDisplayGradientComparisonColor;
  DialogDailyReminderTimePicker({this.headerIcon, this.titlePadding,
  this.cbFunction, this.headerBgColor, this.dailyReminderLists, this.cardColor,
  this.textColor, this.dialogBgColor, this.userHasFullAccess = false, this.buttonColor,
  this.timeDisplayBgColor, this.timeDisplayTextColor, this.timeDisplayGradientComparisonColor});

  @override
  _DialogDailyReminderTimePickerState createState() => _DialogDailyReminderTimePickerState();
}

class _DialogDailyReminderTimePickerState extends State<DialogDailyReminderTimePicker> {
  String formatTimestamp(Timestamp timestamp, {bool withAMPM = true}){
    DateFormat dateFormat;
    if(withAMPM){
      dateFormat = new DateFormat('hh:mm a');
    }
    else{
      dateFormat = new DateFormat('hh:mm');
    }
    DateTime datetime = timestamp.toDate();
    return dateFormat.format(datetime);
  }

  bool timeHasChanged(TimeOfDay newTime, Timestamp oldTime){
    bool hasChanged = false;
    if(newTime != null){
      String formattedOldTime = formatTimestamp(oldTime, withAMPM: false);
      final DateTime now = DateTime.now();
      Timestamp tempNewTime = Timestamp.fromDate(DateTime(now.year, now.month, now.day, newTime.hour, newTime.minute));
      String formattedNewTime = formatTimestamp(tempNewTime, withAMPM: false);
      hasChanged = formattedNewTime != formattedOldTime;
    }
    return hasChanged;
  }

  Timestamp timeOfDayToTimestamp(TimeOfDay newTime){
    final DateTime now = DateTime.now();
    return Timestamp.fromDate(DateTime(now.year, now.month, now.day, newTime.hour, newTime.minute));
  }

  void selectNewTime(String op, int index) async{
    //open time picker
    TimeOfDay newTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(op == 'regularTimes' ? widget.dailyReminderLists.regularTimes[index].toDate() : widget.dailyReminderLists.challengeModeTimes[index].toDate()),
    );
    //run call back with op set to regular times if time changed
    if(timeHasChanged(newTime, op == 'regularTimes' ? widget.dailyReminderLists.regularTimes[index] : widget.dailyReminderLists.challengeModeTimes[index])){
      Timestamp newTimeStamp = timeOfDayToTimestamp(newTime);
      //update time in parent
      widget.cbFunction(op, index, newTimeStamp);
      //update time display in widget
      setState(() {
        if(op == 'regularTimes'){
          widget.dailyReminderLists.regularTimes[index] = newTimeStamp;
        }
        else if(op == 'challengeModeTimes'){
          widget.dailyReminderLists.challengeModeTimes[index] = newTimeStamp;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
      ),
      backgroundColor: widget.dialogBgColor,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: EdgeInsets.only(top: 24, bottom: 24, left: 24, right: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //regular times
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: widget.titlePadding,
                      child: Text(
                        'Daily Reminders',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: widget.textColor
                        ),
                      ),
                    ),
                    Container(
                      child: ListView.builder(
                        itemBuilder: (context, index){
                          return Container(
                            margin: EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(
                                color: widget.cardColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                      gradient: RadialGradient(
                                        colors: [widget.timeDisplayGradientComparisonColor, Color.lerp(widget.timeDisplayBgColor, widget.timeDisplayGradientComparisonColor, 0.01), widget.timeDisplayBgColor],
                                        center: Alignment(-10.5, 0.8),
                                        focal: Alignment(0.3, -0.1),
                                        focalRadius: 13.5,
                                      ),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Text(
                                    formatTimestamp(widget.dailyReminderLists.regularTimes[index]),
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: widget.timeDisplayTextColor
                                    ),
                                  ),
                                ),
                                TextButton(
                                    onPressed: (){
                                      selectNewTime('regularTimes', index);
                                    },
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.grey[50]
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                        backgroundColor: widget.buttonColor,
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                                    ),
                                ),
                              ],
                            )
                          );
                        },
                        itemCount: widget.dailyReminderLists.regularTimes.length,
                        shrinkWrap: true,
                      ),
                    ),
                  ],
                ),
                //challenge mode times if user has full access
                if(widget.userHasFullAccess) Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: widget.titlePadding,
                      child: Text(
                        'Challenge Mode',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: widget.textColor
                        ),
                      ),
                    ),
                    Container(
                      child: ListView.builder(
                        itemBuilder: (context, index){
                          return Container(
                              margin: EdgeInsets.only(top: 12),
                              decoration: BoxDecoration(
                                  color: widget.cardColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                    decoration: BoxDecoration(
                                        gradient: RadialGradient(
                                          colors: [widget.timeDisplayGradientComparisonColor, Color.lerp(widget.timeDisplayBgColor, widget.timeDisplayGradientComparisonColor, 0.01), widget.timeDisplayBgColor],
                                          center: Alignment(-10.5, 0.8),
                                          focal: Alignment(0.3, -0.1),
                                          focalRadius: 13.5,
                                        ),
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Text(
                                      formatTimestamp(widget.dailyReminderLists.challengeModeTimes[index]),
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: widget.timeDisplayTextColor
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: (){
                                      selectNewTime('challengeModeTimes', index);
                                    },
                                    child: Text(
                                        'Edit',
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.grey[50]
                                        ),
                                    ),
                                    style: TextButton.styleFrom(
                                        backgroundColor: widget.buttonColor,
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                                    ),
                                  ),
                                ],
                              )
                          );
                        },
                        itemCount: widget.dailyReminderLists.challengeModeTimes.length,
                        shrinkWrap: true,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 28),
                  child: TextButton(
                    onPressed: (){
                      //close dialog
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.grey[50]
                      ),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: widget.buttonColor,
                        padding: EdgeInsets.symmetric(vertical: 16)
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -45,
            child: CircleAvatar(
              backgroundColor: widget.headerBgColor,
              radius: 40,
              child: Icon(
                widget.headerIcon,
                color: Colors.white,
                size: 50,
              ),
            ),
          )
        ],
      ),
    );
  }
}
