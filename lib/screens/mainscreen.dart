import 'package:flutter/material.dart';
import 'package:scanawake/blocs/appbloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
            Text("empty screen"),
            
          ],
        ));
  }
}
