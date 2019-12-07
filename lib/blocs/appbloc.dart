import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:scanawake/models/alarm.dart';
import 'package:scanawake/screens/disable_alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppBloc extends ChangeNotifier {
  bool isReady = false;
  int numAlarms = 0;

  AudioPlayer networkPlayer = AudioPlayer();
  static AudioCache localCache = AudioCache();
  AudioPlayer localPlayer;
  String chosenTitle = "default";
  String chosenURL = "";
  List<String> titles = List<String>();
  List<String> urls = List<String>();
  String deezerKEY = "3b40ebf5a48debdd33cf1e497c9025df";
  String deezerID = "382824";
  bool ringing = false;
  String player = "local";

  List<Alarm> alarms = List<Alarm>();
  List<Timer> timers = List<Timer>();
  List<int> timerIDs = List<int>();

  BuildContext mainContext;

  AppBloc() {
    //setup();
    alarms = [];
    localCache.load('mp3/alarm_clock.mp3');

    //load from saved stuff

    load();
    notifyListeners();
  }

  void load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedNum = prefs.getInt('numAlarms');
//    prefs.clear();
    if (savedNum != 0 && savedNum != null) {
      numAlarms = savedNum;

      for (int i = 0; i < savedNum; i++) {
        String tmp = prefs.getString('$i');
        Alarm newAlarm = Alarm.fromJson(json.decode(tmp));
        alarms.add(newAlarm);
        timers.add(createTimer(newAlarm));
        timerIDs.add(newAlarm.id);
      }
    }
  }

  void ring(Alarm a) async {
    ringing = true;
    print("playing sound");
    if (a.local)
      localPlayer = await localCache.loop("mp3/alarm_clock.mp3", volume: 0.5);
    else {
      networkPlayer.setReleaseMode(ReleaseMode.LOOP);
      networkPlayer.setVolume(1);
      networkPlayer.play(a.audio);
    }
  }

  void turnOffAlarm(Alarm a) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ringing = false;
    print("turning off alarm");

    // temporary - makes alarm one-time-only
    /*
    prefs.remove('${a.id}');
    alarms.remove(a);
    numAlarms--;
    int timerIndex = timerIDs.indexWhere((id) => id == a.id);
    timerIDs.remove(a.id);
    timers.remove(timerIndex);
    notifyListeners();
    */
    
    if (a.local)
      localPlayer.stop();
    else
      networkPlayer.stop();
  }

  void toggleAlarm(Alarm a) {
    if (a.enabled) {
      print("alarm disabled");
      int timerIndex = timerIDs.indexWhere((id) => id == a.id);
      print("timer index = $timerIndex");
      timerIDs.remove(a.id);
      timers[timerIndex].cancel();
      timers.remove(timerIndex);
      a.enabled = false;
    } else {
      print("alarm enabled");
      int toggleID = timerIDs.indexWhere((id) => id == a.id);
      timers[toggleID] = createTimer(a);
      a.enabled = true;
    }

    notifyListeners();
  }

  Duration getDifference(int h, int m, int d) {
    var alarm;
    var today = new DateTime.now();
    if (today.day == d)
      alarm = new DateTime(today.year, today.month, today.day, h, m);
    else
      alarm = new DateTime(today.year, today.month, d, h, m);

    print("Alarm set to: ${alarm.day} -> ${alarm.hour}:${alarm.minute}");
    Duration difference = alarm.difference(DateTime.now());

    return difference;
  }

  Timer createTimer(Alarm a) {
    Duration difference = getDifference(a.hour, a.minute, a.day);
    print("");
    print("Setting timer for ${a.hour}:${a.minute}");
    ;
    print("");
    return Timer(Duration(seconds: difference.inSeconds), () {
      print("Ring ring ${a.hour}: ${a.minute}");
      ring(a);
      Navigator.push(
        mainContext,
        MaterialPageRoute(builder: (ct) => DisableScreen(a)),
      );
    });
  }

  Future addAlarm(Alarm a) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    alarms.add(a);
    numAlarms++;

    prefs.setInt('numAlarms', numAlarms);
    Map<String, dynamic> jsonAlarm = a.toJson();

    prefs.setString('${numAlarms - 1}', json.encode(jsonAlarm));
    notifyListeners();
  }

  Future<bool> searchAudio(String keyword) async {
    titles.clear();
    urls.clear();
    var response = await http.get("https://api.deezer.com/search?q=$keyword",
        headers: {'secret_key': "$deezerKEY", 'app_id': "$deezerID"});

    if (response.statusCode == 200) {
      Map<String, dynamic> jsondata = json.decode(response.body);
      for (int i = 0; i < jsondata["data"].length; i++) {
        print(jsondata["data"][i]["title"]);
        print(jsondata["data"][i]["preview"]);
        titles.add(jsondata["data"][i]["title"].toString());
        urls.add(jsondata["data"][i]["preview"].toString());
      }
      return true;
    }
    return false;
  }
}
