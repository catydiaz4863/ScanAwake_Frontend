import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:scanawake/blocs/appbloc.dart';
import 'package:scanawake/screens/searchpage.dart';
import 'package:volume/volume.dart';
import 'package:scanawake/components/RoundedInput.dart';
import 'package:scanawake/components/RoundedButton.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class BasicAlarm extends StatefulWidget {
  @override
  _BasicAlarmState createState() => _BasicAlarmState();
}

class _BasicAlarmState extends State<BasicAlarm> {
  
  Future<bool> createAlarm(int h, int m, int d) async {
    var alarm;
    var today = new DateTime.now();
    if (today.day == d) {
      alarm = new DateTime(today.year, today.month, today.day, h, m);
    } else {
      alarm = new DateTime(today.year, today.month, d, h, m);
    }
    print("Alarm set to: ${alarm.day} -> ${alarm.hour}:${alarm.minute}");
    var now = new DateTime.now();

    //print("Current time: ${now.day} -> ${now.hour}:${now.minute}");
    print("Current time: ${today.day} -> ${today.hour}:${today.minute}");

    Duration difference = alarm.difference(today);
    print(
        "difference in days: ${difference.inDays}: hour: ${difference.inHours}, minutes ${difference.inMinutes}, seconds: ${difference.inSeconds}");
    Timer(
        Duration(
            days: difference.inDays,
            hours: difference.inHours,
            minutes: difference.inMinutes,
            seconds: difference.inSeconds), () {
      print("Ring ring ${alarm.hour}: ${alarm.minute}");
      return true;
    });
  }

  int getDay(String day) {
    if (day == "m") //monday
      return 1;
    if (day == "t") //tuesday
      return 2;
    if (day == "w") //wed
      return 3;
    if (day == "r") //thursday
      return 4;
    if (day == "f") //friday
      return 5;
    if (day == "s") //saturday
      return 6;
    if (day == "su") //sunday
      return 7;

    return 0;
  }

  void ring() async {
    print("playing sound");
    //         setVol(maxVol);
    playerCache.load('mp3/alarm_clock.mp3');
    audioPlayer = await playerCache.loop("mp3/alarm_clock.mp3", volume: 0.5);
  }

  AudioPlayer audioPlayer;
  int maxVol;
  static AudioCache playerCache = AudioCache();

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    //  maxVol = await Volume.getMaxVol;
    //  initPlatformState();
  }

  Future<void> initPlatformState() async {
    // pass any stream as parameter as per requirement
    await Volume.controlVolume(AudioManager.STREAM_MUSIC);
  }

/*
 setVol(int i) async {
    await Volume.setVol(i);
  }*/

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController hourCtrl = TextEditingController();
    TextEditingController minuteCtrl = TextEditingController();
    TextEditingController dayCtrl = TextEditingController();

    AppBloc bloc = Provider.of<AppBloc>(context);
    bool flag = false;
    TextEditingController searchCtrl = new TextEditingController();

    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
            child: RoundedInput(
          txtCtrl: hourCtrl,
          hintText: "hour",
        )),
        new Container(
            child: RoundedInput(
          txtCtrl: minuteCtrl,
          hintText: "minute",
        )),
        new Container(
          child: RoundedInput(
            txtCtrl: dayCtrl,
            hintText: "day of the week",
          ),
        ),
        new Container(
            child: RaisedButton(
                child: Text("submit AM"),
                onPressed: () async {
                  flag = await createAlarm(int.parse(hourCtrl.text),
                      int.parse(minuteCtrl.text), int.parse(dayCtrl.text));

                  print("playing sound");
                  flag ? ring() : print("not ringing");
                  flag
                      ? Row(children: <Widget>[
                          Text("ringing"),
                          RoundedButton(
                            onPressed: () {
                              audioPlayer.stop();
                            },
                            text: "off",
                          )
                        ])
                      : Text("");
                })),
        new Container(
            child: RaisedButton(
          child: Text("submit PM"),
          onPressed: () async {
            int h = int.parse(hourCtrl.text);
            h += 12;
            flag = await createAlarm(
                h, int.parse(minuteCtrl.text), int.parse(dayCtrl.text));

                  print("playing sound");
            flag ? ring() : print("not ringing");
            flag
                ? Row(children: <Widget>[
                    Text("ringing"),
                    RoundedButton(
                      onPressed: () {
                        audioPlayer.stop();
                      },
                      text: "off",
                    )
                  ])
                : Text("");
          },
        )),
      ],
    )));
  }
}
