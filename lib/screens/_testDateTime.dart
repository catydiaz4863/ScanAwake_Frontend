import 'dart:async';

import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class DateandTime extends StatefulWidget {
  @override
  _DateandTimeState createState() => _DateandTimeState();
}

class _DateandTimeState extends State<DateandTime> {
  void createAlarm(int h, int m, int d) async {
    var alarm;
    var today = new DateTime.now();
    if(today.day == d)
    {
      alarm = new DateTime(today.year, today.month, today.day, h, m);
      
    }
    else{
       alarm = new DateTime(today.year, today.month, d, h, m);
    }
    print("Alarm set to: ${alarm.day} -> ${alarm.hour}:${alarm.minute}");
    var now = new DateTime.now();

    //print("Current time: ${now.day} -> ${now.hour}:${now.minute}");
    print("Current time: ${today.day} -> ${today.hour}:${today.minute}");

    Duration difference = alarm.difference(today); 
    print("difference in days: ${difference.inDays}: hour: ${difference.inHours}, minutes ${difference.inMinutes}, seconds: ${difference.inSeconds}");
    Timer(Duration(days: difference.inDays, hours: difference.inHours, minutes: difference.inMinutes, seconds: difference.inSeconds), () {
      print("Ring ring ${alarm.hour}: ${alarm.minute}");
    });
  }


  int getDay(String day) {
    if (day == "m") //monday
    {
      return 1;
    }
    if (day == "t") //tuesday
    {
      return 2;
    }
    if (day == "w") //wed
    {
      return 3;
    }
    if (day == "r") //thursday
    {
      return 4;
    }
    if (day == "f") //friday
    {
      return 5;
    }
    if (day == "s") //saturday
    {
      return 6;
    }
    if (day == "su") //sunday
    {
      return 7;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController hourCtrl = TextEditingController();
    TextEditingController minuteCtrl = TextEditingController();
    TextEditingController dayCtrl = TextEditingController();

    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
            child: TextFormField(
          controller: hourCtrl,
        )),
        new Container(
            child: TextFormField(
          controller: minuteCtrl,
        )),
        new Container(
          child: TextFormField(
            controller: dayCtrl,
          ),
        ),
        new Container(
            child: RaisedButton(
          child: Text("sumbit AM"),
          onPressed: () {
          
            createAlarm(
                int.parse(hourCtrl.text), int.parse(minuteCtrl.text), int.parse(dayCtrl.text));
          },
        )),

         new Container(
            child: RaisedButton(
          child: Text("sumbit PM"),
          onPressed: () {
          int h = int.parse(hourCtrl.text);
          h +=12;
            createAlarm(
                h, int.parse(minuteCtrl.text), int.parse(dayCtrl.text));
          },
        ))
      ],
    )));
  }
}
