import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scanawake/blocs/appbloc.dart';
import 'package:scanawake/components/EditableAlarmCard.dart';
import 'package:scanawake/components/RoundedButton.dart';
import 'package:scanawake/consts.dart';
import 'package:scanawake/models/alarm.dart';

class EditAlarmScreen extends StatefulWidget {
  EditAlarmScreen({Key key, this.newAlarm: false, this.alarm})
      : super(key: key);
  final Alarm alarm;
  final bool newAlarm;

  @override
  _EditAlarmScreenState createState() => _EditAlarmScreenState();
}

class OptionButton extends StatelessWidget {
  const OptionButton({Key key, this.icon, this.text, this.onPressed})
      : super(key: key);
  final IconData icon;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onPressed(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colorScheme[0].withOpacity(.7),
          ),
          width: 100,
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 36,
              ),
              Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    text,
                    style: subtleText.apply(
                        color: colorScheme[6], fontWeightDelta: 2),
                  )),
            ],
          ),
        ));
  }
}

class _EditAlarmScreenState extends State<EditAlarmScreen> {
  Alarm _alarm;
  // TODO: Finish/fix when we alolow multiple days/alarm...
  bool ready;
  Color _disabledGrey = primaryGrey.withOpacity(.75);

  @override
  void initState() {
    super.initState();

    ready = false;

    if (widget.alarm == null) {
      _alarm = new Alarm(
          day: null,
          enabled: true,
          hour: 0,
          minute: 0,
          soundLevel: 0,
          vibrationLevel: 0);
    } else {
      _alarm = widget.alarm;
    }
  }

  @override
  Widget build(BuildContext context) {
    AppBloc bloc = Provider.of<AppBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Alarm"),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: <Widget>[
              // TODO: Make data come back.
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: EditableAlarmCard(
                  alarm: _alarm,
                ),
              ),

              // TODO: Finish Active Days Section
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    color: colorScheme[0].withOpacity(.7),
                    borderRadius: BorderRadius.circular(20)),
                height: 90,
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: ListView.builder(
                          physics: new BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.5, vertical: 2),
                              child: Container(
                                width: 40,
                                child: InkWell(
                                    onLongPress: () {
                                      // TODO: Make it reflect changes on whatever we store it in. (Not just visually)
                                    },
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          days[index].first,
                                          textAlign: TextAlign.center,
                                          style: smSectionText.apply(
                                              fontWeightDelta: index ==
                                                      dayToRelativeRange(
                                                          _alarm.day)
                                                  ? 2
                                                  : 1,
                                              color: _alarm.enabled
                                                  ? (index ==
                                                          dayToRelativeRange(
                                                              _alarm.day)
                                                      ? bloc.appColor
                                                      : _disabledGrey)
                                                  : (index ==
                                                          dayToRelativeRange(
                                                              _alarm.day)
                                                      ? primaryGrey
                                                          .withOpacity(.7)
                                                      : _disabledGrey
                                                          .withOpacity(.6))),
                                        ))),
                              ),
                            );
                          },
                          itemCount: 7,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    )),
              ),

              // TODO: Add 2x2 Grid (Using GridView instead of manual row/column) with changes
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: GridView.count(
                      primary: false,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      crossAxisCount: 2,
                      children: <Widget>[
                        OptionButton(
                          text: 'Change Sound',
                          icon: Icons.music_note,
                          onPressed: () {},
                        ),
                        OptionButton(
                          text: 'Wake-up Check',
                          icon: Icons.cached,
                          onPressed: () {},
                        ),
                        OptionButton(
                          text: 'Time Pressure',
                          icon: Icons.timer,
                          onPressed: () {},
                        ),
                        OptionButton(
                          text: 'Mission Settings',
                          icon: Icons.directions_run,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // TODO: Add Row with Save/Cancel
              Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RoundedButton(
                        width: MediaQuery.of(context).size.width / 4,
                        borderRadius: 10,
                        buttonColor: bloc.appColor,
                        text: 'Save',
                        onPressed: () {},
                      ),
                      RoundedButton(
                        width: MediaQuery.of(context).size.width / 4,
                        borderRadius: 10,
                        buttonColor: primaryGrey,
                        text: 'Cancel',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
}
