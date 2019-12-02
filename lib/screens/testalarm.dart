import 'package:flutter/material.dart';
import 'package:scanawake/blocs/appbloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:scanawake/screens/searchpage.dart';
import 'package:volume/volume.dart';
import 'package:scanawake/components/RoundedInput.dart';
import 'package:scanawake/components/RoundedButton.dart';

class TestAlarmScreen extends StatefulWidget {
  @override
  _TestAlarmScreenState createState() => _TestAlarmScreenState();
}

class _TestAlarmScreenState extends State<TestAlarmScreen> {
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
    AppBloc bloc = Provider.of<AppBloc>(context);
    DateTime current;
    TextEditingController searchCtrl = new TextEditingController();
    String url = "";

    return Scaffold(
        appBar: AppBar(
          title: Text("ScanAwake"),
        ),
        body: ListView(
          //      mainAxisAlignment: MainAxisAlignment.center,
          //      crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("testing sound control with audioplayer plugin"),
            Text("Example #1 : George Strait"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // https://cdns-preview-1.dzcdn.net/stream/c-1cdfe90120447061efa70135a552152c-10.mp3
                RaisedButton(
                    child: Text("on"),
                    onPressed: () async {
                      print("playing sound");

                      //         setVol(maxVol);
                      audioPlayer.setReleaseMode(ReleaseMode.LOOP);
                      audioPlayer.setVolume(0.5);
                      audioPlayer.play(
                          "https://cdns-preview-6.dzcdn.net/stream/c-6f19a7e44697f2ba83240fa0620d5e0a-6.mp3");
                    }),
                RaisedButton(
                  onPressed: () {
                    print("stopping sound");
                    audioPlayer.stop();
                  },
                  child: Text("off"),
                ),
              ],
            ),
            Text("Example #2 : GoT theme song"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    child: Text("on"),
                    onPressed: () async {
                      print("playing sound");

                      //         setVol(maxVol);
                      audioPlayer.setReleaseMode(ReleaseMode.LOOP);
                      audioPlayer.setVolume(2.0);
                      audioPlayer.play(
                          "https://cdns-preview-0.dzcdn.net/stream/c-08c6521daf18d7fc58234a4b2602d1ff-4.mp3");
                    }),
                RaisedButton(
                  onPressed: () {
                    print("stopping sound");
                    audioPlayer.stop();
                  },
                  child: Text("off"),
                ),
              ],
            ),
            Text("Example #3 : Linkin Park"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    child: Text("on"),
                    onPressed: () async {
                      print("playing sound");

                      //         setVol(maxVol);
                      audioPlayer.setReleaseMode(ReleaseMode.LOOP);
                      audioPlayer.setVolume(2.0);
                      audioPlayer.play(
                          "https://cdns-preview-1.dzcdn.net/stream/c-1cdfe90120447061efa70135a552152c-10.mp3");
                    }),
                RaisedButton(
                  onPressed: () {
                    print("stopping sound");
                    audioPlayer.stop();
                  },
                  child: Text("off"),
                ),
              ],
            ),
            Text("Testing local asset use"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    child: Text("on"),
                    onPressed: () async {
                      print("playing sound");

                      //         setVol(maxVol);
                      playerCache.load('mp3/alarm_clock.mp3');

                      audioPlayer = await playerCache
                          .loop("mp3/alarm_clock.mp3", volume: 0.5);
                    }),
                RaisedButton(
                  onPressed: () {
                    print("stopping sound");
                    audioPlayer.stop();
                  },
                  child: Text("off"),
                ),
              ],
            ),
            Text("Testing audio picker and use"),
            Row(
              children: <Widget>[
                Text("Currently selected: ${bloc.chosenTitle}"),
                Spacer(),
                (bloc.chosenTitle != "default")
                ?
                FlatButton(
                  child: Text("Clear"),
                  onPressed: () {
                    bloc.chosenURL = "";
                    bloc.chosenTitle = "default";
                    setState(() {
                      
                    });
                  },
                )
                :
                Text(""),
                Spacer(),
                Text("")
              ],
            ),
            RoundedInput(
              hintText: "Search by keyword",
              txtCtrl: searchCtrl,
            ),
            RoundedButton(
              text: "Search",
              onPressed: () async {
                if (!searchCtrl.text.isEmpty) {
                  bool flag = await bloc.searchAudio(searchCtrl.text);
                  if (flag && bloc.titles.length != 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  }
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    child: Text("on"),
                    onPressed: () async {
                      print("playing sound");

                      //         setVol(maxVol);
                      audioPlayer.setReleaseMode(ReleaseMode.LOOP);
                      audioPlayer.setVolume(0.1);
                      if (bloc.chosenURL != "")
                        audioPlayer.play(bloc.chosenURL);
                    }),
                RaisedButton(
                  onPressed: () {
                    print("stopping sound");
                    audioPlayer.stop();
                  },
                  child: Text("off"),
                ),
              ],
            ),
            Text("testing sound control with flutter ringtone player plugin"),
            RaisedButton(
                child: Text("on"),
                onPressed: () async {
                  print("playing sound");
                  FlutterRingtonePlayer.play(
                    android: AndroidSounds.alarm,
                    ios: IosSounds.alarm,
                    looping: true,
                    volume: 1,
                  );
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
