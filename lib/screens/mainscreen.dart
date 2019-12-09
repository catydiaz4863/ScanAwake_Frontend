import 'package:flutter/material.dart';
import 'package:scanawake/blocs/appbloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:scanawake/components/AddAlarmCard.dart';
import 'package:scanawake/components/AlarmCard.dart';
import 'package:scanawake/consts.dart';
import 'package:scanawake/models/alarm.dart';
import 'package:scanawake/screens/create_basic_alarm.dart';

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

  Widget _buildAlarms(AppBloc bloc) {
    if (bloc.alarmsLoaded) {
      return bloc.numAlarms != 0
          ? Expanded(
              child: new ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: bloc.numAlarms,
                itemBuilder: (BuildContext c, int index) {
                  Alarm current = bloc.alarms[index];
                  return Padding(
                      padding: EdgeInsets.only(bottom: 5, top: 10),
                      child: AlarmCard(
                        alarm: current,
                        accentColor: bloc.appColor,
                      ));
                },
              ),
            )
          : Container();
    } else {
      return CircularProgressIndicator(
        strokeWidth: 5,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AppBloc bloc = Provider.of<AppBloc>(context);
    bloc.mainContext = context;

    return Scaffold(
        // appBar: AppBar(
        //   title: Text("ScanAwake"),
        // ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _buildAlarms(bloc),
                  bloc.alarmsLoaded
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: AddAlarmCard(
                            buttonColor: bloc.appColor,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateBasicAlarm(bloc.mainContext)),
                              );
                            },
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ));
  }
}
