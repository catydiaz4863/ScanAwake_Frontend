import 'package:flutter/material.dart';
import 'package:scanawake/blocs/appbloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _widgetOptions = <Widget>[];
  }

  @override
  Widget build(BuildContext context) {
    AppBloc bloc = Provider.of<AppBloc>(context);
    DateTime current;

    return Scaffold(
        appBar: AppBar(
          title: Text("ScanAwake"),
        ),
        body: SafeArea(
            child: Column(
          children: <Widget>[
            Text("empty screen"),
          ],
        )));
  }
}
