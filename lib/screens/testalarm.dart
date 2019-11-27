import 'package:flutter/material.dart';
import 'package:scanawake/blocs/appbloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:audioplayers/audioplayers.dart';

class TestAlarmScreen extends StatefulWidget {
  @override
  _TestAlarmScreenState createState() => _TestAlarmScreenState();
}

class _TestAlarmScreenState extends State<TestAlarmScreen> {
  @override
  Widget build(BuildContext context) {
    AppBloc bloc = Provider.of<AppBloc>(context);
    DateTime current;
    AudioPlayer audioPlayer = new AudioPlayer();


    return Scaffold(
        appBar: AppBar(
          title: Text("ScanAwake"),
        ),
        body: Column(
          children: <Widget>[
            Text("testing sound control with audioplayer plugin"),
            RaisedButton(
                child: Text("on"),
                onPressed: () async {
                  print("playing sound");

                  audioPlayer.setVolume(0.1);
                  audioPlayer.play(
                      "https://cdns-preview-6.dzcdn.net/stream/c-6f19a7e44697f2ba83240fa0620d5e0a-6.mp3");
                  /*     FlutterRingtonePlayer.play(
                    android: AndroidSounds.alarm,
                    ios: IosSounds.alarm,
                    looping: true,
                    volume: 1,
                  ); */
                }),
            RaisedButton(
              onPressed: () {
                print("stopping sound");
                audioPlayer.stop();
                //       FlutterRingtonePlayer.stop();
              },
              child: Text("off"),
            )
          ],
        ));
  }
}
