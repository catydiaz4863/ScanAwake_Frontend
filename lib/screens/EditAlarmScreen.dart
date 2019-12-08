import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanawake/blocs/appbloc.dart';
import 'package:scanawake/components/EditableAlarmCard.dart';
import 'package:scanawake/models/alarm.dart';

class EditAlarmScreen extends StatefulWidget {
  EditAlarmScreen({Key key, this.alarmId, this.newAlarm: false})
      : super(key: key);
  final int alarmId;
  final bool newAlarm;

  @override
  _EditAlarmScreenState createState() => _EditAlarmScreenState();
}

class _EditAlarmScreenState extends State<EditAlarmScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    AppBloc bloc = Provider.of<AppBloc>(context);
    Alarm alarm;
    TimeOfDay alarmTime;

    if (widget.newAlarm) {
      alarmTime = TimeOfDay.now();
      alarm = new Alarm(
          enabled: true,
          hour: alarmTime.hour - 1,
          minute: alarm.minute,
          soundLevel: 0,
          vibrationLevel: 0);
    } else {
      alarm = bloc.alarms
          .firstWhere((alarm) => alarm.id == widget.alarmId, orElse: null);
      alarmTime = TimeOfDay(hour: alarm.hour - 1, minute: alarm.minute);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Alarm"),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: <Widget>[
              // TODO: Add editable Alarm Card
              EditableAlarmCard(
                  alarmId: alarm.id, time: alarmTime, enabled: alarm.enabled),

              // TODO: Add Active Days Section

              // TODO: Add 2x2 Grid with changes

              // TODO: Add Row with Save/Cancel
            ],
          ),
        ));
  }
}
