import 'package:flutter/material.dart';
import 'package:scanawake/blocs/appbloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';


class TestAlarmScreen extends StatefulWidget {
  @override
  _TestAlarmScreenState createState() => _TestAlarmScreenState();
}

class _TestAlarmScreenState extends State<TestAlarmScreen> {
  @override
  Widget build(BuildContext context) {
    AppBloc bloc = Provider.of<AppBloc>(context);
    DateTime current;
    return Scaffold(
        appBar: AppBar(
          title: Text("ScanAwake"),
        ),
        body: Column(
          children: <Widget>[
            Text("testing sound control"),
            RaisedButton(
                child: Text("on"),
                onPressed: () async {
                  //       current = DateTime.now().toUtc().add(Duration(seconds: 5));
                  //        await Future.delayed(Duration(seconds: 5));
                  print("playing sound");

                  FlutterRingtonePlayer.play(
                    android: AndroidSounds.alarm,
                    ios: IosSounds.alarm,
                    looping: true,
                    volume: 1,
                  );
                  //           if (DateTime.now() == current) {
                  //       FlutterRingtonePlayer.playAlarm(volume: 0.5);
                  //           }
                }),
            RaisedButton(
              onPressed: () {
                print("stopping sound");

                FlutterRingtonePlayer.stop();
              },
              child: Text("off"),
            )
          ],
        ));
  }
}
