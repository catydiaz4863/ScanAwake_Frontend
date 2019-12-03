import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:scanawake/models/alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:scanawake/models/user.dart';

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

  AppBloc() {
    //setup();
    alarms = [];
    localCache.load('mp3/alarm_clock.mp3');

    //load from saved stuff
    notifyListeners();
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

  void turnOffAlarm(Alarm a) {
    ringing = false;
    print("turning off alarm");

    if (a.local)
      localPlayer.stop();
    else
      networkPlayer.stop();
  }

  void addAlarm(Alarm a) {
    alarms.add(a);
    numAlarms++;
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
