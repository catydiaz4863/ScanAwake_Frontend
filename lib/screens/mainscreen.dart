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
<<<<<<< HEAD

    return Scaffold(
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
       //its going to return alarm cards
       
      ],
    )
          
    );
=======
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
>>>>>>> 228120885e0587fe79a529a13a8755619c6ca08c
  }
}
