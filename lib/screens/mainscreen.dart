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

  @override
  Widget build(BuildContext context) {
    AppBloc bloc = Provider.of<AppBloc>(context);
    bloc.mainContext = context;

    return Scaffold(
        appBar: AppBar(
          title: Text("ScanAwake"),
        ),
        body: SafeArea(
          child: Container(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  bloc.numAlarms != 0
                      ? Expanded(
                          child: new ListView.builder(
                            itemCount: bloc.numAlarms,
                            itemBuilder: (BuildContext c, int index) {
                              Alarm current = bloc.alarms[index];

                              List<bool> days = [
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false
                              ];
                              days[current.day - 1] = true;
                              TimeOfDay alarmTime = TimeOfDay(
                                  hour: current.hour - 1,
                                  minute: current.minute); // 3:00pm
                              return Dismissible(
                                child: AlarmCard(
                                  thisAlarm: current,
                                  enabled: true,
                                  daysEnabled: days,
                                  time: alarmTime,
                                  accentColor: Colors.purple,
                                ),
                                key: ObjectKey(current.id),
                                background: stackBehindDismiss(),
                                onDismissed: (direction) {
                                  bloc.deleteAlarm(current);
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        )
                      : Text(""),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: AddAlarmCard(
                      buttonColor: Colors.purple,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CreateBasicAlarm(bloc.mainContext)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

Widget stackBehindDismiss() {
  return Container(
    alignment: Alignment.centerRight,
    padding: EdgeInsets.only(right: 20.0),
    color: Colors.red,
    child: Icon(
      Icons.delete,
      color: Colors.white,
    ),
  );
}
