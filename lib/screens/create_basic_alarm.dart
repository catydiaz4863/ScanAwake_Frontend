import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanawake/blocs/appbloc.dart';
import 'package:scanawake/screens/searchpage.dart';
import 'package:scanawake/components/RoundedInput.dart';
import 'package:scanawake/models/alarm.dart';

class CreateBasicAlarm extends StatefulWidget {
  BuildContext mainct;
  CreateBasicAlarm(this.mainct);

  @override
  _CreateBasicAlarmState createState() => _CreateBasicAlarmState();
}

class _CreateBasicAlarmState extends State<CreateBasicAlarm> {
  int getDay(String day) {
    if (day == "m") //monday
      return 1;
    if (day == "t") //tuesday
      return 2;
    if (day == "w") //wed
      return 3;
    if (day == "r") //thursday
      return 4;
    if (day == "f") //friday
      return 5;
    if (day == "s") //saturday
      return 6;
    if (day == "su") //sunday
      return 7;
    return 0;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Alarm newAlarm;
    TextEditingController hourCtrl = TextEditingController();
    TextEditingController minuteCtrl = TextEditingController();
    TextEditingController dayCtrl = TextEditingController();

    AppBloc bloc = Provider.of<AppBloc>(context);
    bool flag = false;
    TextEditingController searchCtrl = new TextEditingController();
    BuildContext ct;

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Container(
            child: RoundedInput(
          txtCtrl: hourCtrl,
          hintText: "Enter hour",
          width: 150,
        )),
        new Container(
            child: RoundedInput(
          txtCtrl: minuteCtrl,
          hintText: "Enter minute",
          width: 150,
        )),
        new Container(
          child: RoundedInput(
            txtCtrl: dayCtrl,
            hintText: "Enter day",
            width: 150,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Currently selected: ${bloc.chosenTitle}"),
            (bloc.chosenTitle != "default")
                ? FlatButton(
                    child: Text("Clear"),
                    onPressed: () {
                      bloc.chosenURL = "";
                      bloc.chosenTitle = "default";
                      setState(() {});
                    },
                  )
                : Text(""),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RoundedInput(
              hintText: "Search by keyword",
              txtCtrl: searchCtrl,
              width: 200,
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                if (searchCtrl.text.isNotEmpty) {
                  bool flag = await bloc.searchAudio(searchCtrl.text);
                  if (flag && bloc.titles.length != 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchPage(searchCtrl.text)),
                    );
                  }
                }
              },
            )
          ],
        ),
        new Container(
            child: RaisedButton(
                child: Text("submit AM"),
                onPressed: () async {
                  int h = int.parse(hourCtrl.text);
                  int m = int.parse(minuteCtrl.text);
                  int d = int.parse(dayCtrl.text);

                  int newID = bloc.numAlarms;
                  Alarm a;
                  if (bloc.chosenTitle == "default") {
                    a = new Alarm(
                        id: newID,
                        text: "default",
                        day: d,
                        hour: h,
                        minute: m,
                        enabled: true,
                        audio: "",
                        local: true);
                  } else {
                    a = new Alarm(
                        id: newID,
                        text: "${bloc.chosenTitle}",
                        day: d,
                        hour: h,
                        minute: m,
                        enabled: true,
                        audio: "${bloc.chosenURL}",
                        local: false);
                  }
                  bloc.addAlarm(a);
                  print("alarm created");
                  bloc.chosenURL = "";
                  bloc.chosenTitle = "default";
                  setState(() {});

                  bloc.timerIDs.add(a.id);
                  bloc.timers.add(bloc.createTimer(a));
                  Navigator.pop(context);
                })),
        new Container(
            child: RaisedButton(
          child: Text("submit PM"),
          onPressed: () async {
            int h = int.parse(hourCtrl.text);
            h += 12;
            int m = int.parse(minuteCtrl.text);
            int d = int.parse(dayCtrl.text);

            int newID = bloc.numAlarms;
            Alarm a;
            if (bloc.chosenTitle == "default") {
              a = new Alarm(
                  id: newID,
                  text: "default",
                  day: d,
                  hour: h,
                  minute: m,
                  enabled: true,
                  audio: "",
                  local: true, vibrationLevel: 0.0, soundLevel: 0.0);
            } else {
              a = new Alarm(
                  id: newID,
                  text: "${bloc.chosenTitle}",
                  day: d,
                  hour: h,
                  minute: m,
                  enabled: true,
                  audio: "${bloc.chosenURL}",
                  local: false, vibrationLevel: 0.0, soundLevel: 0.0);
            }
            bloc.addAlarm(a);
            print("alarm created");
            bloc.chosenURL = "";
            bloc.chosenTitle = "default";
            setState(() {});

            bloc.timerIDs.add(a.id);
            bloc.timers.add(bloc.createTimer(a));
            Navigator.pop(context);
          },
        )),
      ],
    ));
  }
}
