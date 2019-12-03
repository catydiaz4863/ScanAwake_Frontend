import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scanawake/components/Seperator.dart';
import 'package:scanawake/consts.dart';
import 'package:vibration/vibration.dart';

// NOTE: Currently, days are passed in/read as [true, true, false, false, false, true, false] ([Sunday, Monday, Tusday, Wednesday, Thursday, Friday, Saturday])
// TODO: FutureBuilder Based on hasVibration && hasVibrationAmplitude to know whether to use a slider with multiple amplitudes. Or just an on/off slider. (or neither)
// TODO: When wrapping time, update else. (ex. when going to one's upper/lower limit -> update other value's number...)
// TODO: Figure out how to manipulate _time_edit values to set clock!

/// Card for showing editable alarm.
///
/// ```dart
/// EditableAlarmCard(enabled: true, daysEnabled: [false, true, true, true, true, true, false])
/// ```
class EditableAlarmCard extends StatefulWidget {
  EditableAlarmCard(
      {Key key,
      this.alarmId,
      this.vibrateSliderValue = 0.0,
      this.volumeSliderValue = 0.0,
      this.enabled = true,
      this.time,
      this.daysEnabled = const [
        false,
        false,
        false,
        false,
        false,
        false,
        false
      ],
      this.backgroundColor,
      this.borderRadius = 30.0,
      this.accentColor,
      this.height,
      this.editMode = false})
      : super(key: key);

  final bool enabled, alarmId, editMode;
  final TimeOfDay time;
  final List<bool> daysEnabled;
  final Color backgroundColor, accentColor;
  final double height, borderRadius, vibrateSliderValue, volumeSliderValue;

  @override
  _EditableAlarmCardState createState() => _EditableAlarmCardState();
}

class _EditableAlarmCardState extends State<EditableAlarmCard> {
  bool _enabled, _mainView;
  TimeOfDay _time;
  List<bool> _daysEnabled;
  double _vibrateSliderVal, _volumeSliderVal;
  // [hour, min_ten, min_one, am/pm]
  List<dynamic> _time_edit = [];
  List<bool> _updateTime = [];
  List<bool> _loopingTime = [];

  @override
  void initState() {
    super.initState();

    _enabled = widget.enabled;
    _time = widget.time == null ? new TimeOfDay.now() : widget.time;
    _time_edit.add(_time.hour % 12 + 1);
    _time_edit
        .add(_time.minute < 10 ? 0 : int.parse(_time.minute.toString()[0]));
    _time_edit.add(_time.minute < 10
        ? _time.minute
        : int.parse(_time.minute.toString()[1]));
    _time_edit.add(_time.hour <= 12 ? 'AM' : 'PM');
    _daysEnabled = widget.daysEnabled;
    _mainView = true;
    _vibrateSliderVal = widget.vibrateSliderValue;
    _volumeSliderVal = widget.volumeSliderValue;
    _updateTime = [false, false, false, false];
    _loopingTime = [false, false, false, false];
  }

  vibrate() async {
    if (await Vibration.hasVibrator()) {
      if (await Vibration.hasAmplitudeControl()) {
        Vibration.vibrate(
            amplitude: (_vibrateSliderVal * 25.5).floor(), duration: 500);
      } else {
        Vibration.vibrate(duration: 500);
      }
    }
  }

  testVolume() async {}

  updateAMPM() async {
    if (_loopingTime[3]) return;

    _loopingTime[3] = true;

    while (_updateTime[3]) {
      setState(() {
        _time_edit[3] = _time_edit[3] == 'AM' ? 'PM' : 'AM';
      });

      await Future.delayed(Duration(milliseconds: 225));
    }

    _loopingTime[3] = false;
  }

  updateMinTen({pos: true}) async {
    if (_loopingTime[1]) return;

    _loopingTime[1] = true;

    while (_updateTime[1]) {
      if (pos) {
        int val = _time_edit[1] % 6 + 1;

        setState(() {
          _time_edit[1] = val == 6 ? 0 : val;
        });
      } else {
        setState(() {
          _time_edit[1] = (_time_edit[1] - 1) % 6;
        });
      }

      await Future.delayed(Duration(milliseconds: 225));
    }

    _loopingTime[1] = false;
  }

  updateMinOne({pos: true}) async {
    if (_loopingTime[2]) return;

    _loopingTime[2] = true;

    while (_updateTime[2]) {
      if (pos) {
        int val = _time_edit[2] % 10 + 1;

        setState(() {
          _time_edit[2] = val == 10 ? 0 : val;
        });
      } else {
        setState(() {
          _time_edit[2] = (_time_edit[2] - 1) % 10;
        });
      }

      await Future.delayed(Duration(milliseconds: 225));
    }

    _loopingTime[2] = false;
  }

  updateHour({pos: true}) async {
    if (_loopingTime[0]) return;

    _loopingTime[0] = true;

    while (_updateTime[0]) {
      if (pos) {
        setState(() {
          _time_edit[0] = (_time_edit[0] % 12) + 1;
        });
      } else {
        int val = (_time_edit[0] - 1) % 12;

        setState(() {
          _time_edit[0] = val == 0 ? 12 : val;
        });
      }

      await Future.delayed(Duration(milliseconds: 225));
    }

    _loopingTime[0] = false;
  }

  Widget vibrationSection(Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Vibration',
                    style: linkText.apply(
                        color: _enabled ? colorScheme[6] : _disabledGrey),
                  ))),
          Container(
              height: 37.5,
              child: Slider(
                min: 0.0,
                max: 10.0,
                value: _vibrateSliderVal,
                activeColor: _enabled ? color : _disabledGrey,
                inactiveColor: _disabledGrey.withOpacity(.25),
                onChanged: (v) async {
                  setState(() {
                    _vibrateSliderVal = v;
                  });

                  vibrate();
                },
                divisions: 10,
              ))
        ],
      ),
    );
  }

  Widget volumeSection(Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Volume',
                    style: linkText.apply(
                        color: _enabled ? colorScheme[6] : _disabledGrey),
                  ))),
          Container(
              height: 37.5,
              child: Slider(
                min: 0.0,
                max: 10.0,
                value: _volumeSliderVal,
                activeColor: _enabled ? color : _disabledGrey,
                inactiveColor: _disabledGrey.withOpacity(.25),
                onChanged: (v) async {
                  setState(() {
                    _volumeSliderVal = v;
                  });

                  testVolume();
                },
                divisions: 10,
              ))
        ],
      ),
    );
  }

  Widget timeSection(Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          children: <Widget>[
            IntrinsicWidth(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Listener(
                      onPointerDown: (_) async {
                        _updateTime[0] = true;

                        updateHour(pos: true);
                      },
                      onPointerUp: (_) {
                        _updateTime[0] = false;
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Icon(
                          Icons.arrow_drop_up,
                          color: color,
                        ),
                      )),
                  Container(
                      child: RichText(
                    textScaleFactor:
                        1.075, // ! Scaling up since size seems smaller in RichText...
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: _time_edit[0] >= 10
                              ? '${_time_edit[0].toString()[0]} '
                              : '${_time_edit[0]}',
                        ),
                        TextSpan(
                            text: _time_edit[0] < 10
                                ? ''
                                : '${_time_edit[0].toString()[1]}'),
                      ],
                      style: sectionText.apply(
                          color: _enabled ? colorScheme[6] : _disabledGrey),
                    ),
                  )),
                  Listener(
                      onPointerDown: (_) async {
                        _updateTime[0] = true;

                        updateHour(pos: false);
                      },
                      onPointerUp: (_) {
                        _updateTime[0] = false;
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: color,
                        ),
                      )),
                ],
              ),
            ),
            Text(
              ' : ',
              style: sectionText.apply(
                  color: _enabled ? colorScheme[6] : _disabledGrey),
            ),
            IntrinsicWidth(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Listener(
                      onPointerDown: (_) async {
                        _updateTime[1] = true;

                        updateMinTen(pos: true);
                      },
                      onPointerUp: (_) {
                        _updateTime[1] = false;
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Icon(
                          Icons.arrow_drop_up,
                          color: color,
                        ),
                      )),
                  Container(
                    child: Text(
                      '${_time_edit[1]}',
                      style: sectionText.apply(
                          color: _enabled ? colorScheme[6] : _disabledGrey),
                    ),
                  ),
                  Listener(
                      onPointerDown: (_) async {
                        _updateTime[1] = true;

                        updateMinTen(pos: false);
                      },
                      onPointerUp: (_) {
                        _updateTime[1] = false;
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: color,
                        ),
                      )),
                ],
              ),
            ),
            Text(
              ' ',
              style: sectionText.apply(
                  color: _enabled ? colorScheme[6] : _disabledGrey),
            ),
            IntrinsicWidth(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Listener(
                      onPointerDown: (_) async {
                        _updateTime[2] = true;

                        updateMinOne(pos: true);
                      },
                      onPointerUp: (_) {
                        _updateTime[2] = false;
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Icon(
                          Icons.arrow_drop_up,
                          color: color,
                        ),
                      )),
                  Container(
                    child: Text(
                      "${_time_edit[2]}",
                      style: sectionText.apply(
                          color: _enabled ? colorScheme[6] : _disabledGrey),
                    ),
                  ),
                  Listener(
                      onPointerDown: (_) async {
                        _updateTime[2] = true;

                        updateMinOne(pos: false);
                      },
                      onPointerUp: (_) {
                        _updateTime[2] = false;
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: color,
                        ),
                      )),
                ],
              ),
            ),
            Text(
              ' ',
              style: sectionText.apply(
                  color: _enabled ? colorScheme[6] : _disabledGrey),
            ),
            IntrinsicWidth(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Listener(
                    onPointerDown: (_) async {
                      _updateTime[3] = true;

                      updateAMPM();
                    },
                    onPointerUp: (_) {
                      _updateTime[3] = false;
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Icon(
                        Icons.arrow_drop_up,
                        color: color,
                      ),
                    )),
                Container(
                  child: Text(
                    "${_time_edit[3]}",
                    style: sectionText.apply(
                        color: _enabled ? colorScheme[6] : _disabledGrey),
                  ),
                ),
                Listener(
                    onPointerDown: (_) async {
                      _updateTime[3] = true;

                      updateAMPM();
                    },
                    onPointerUp: (_) {
                      _updateTime[3] = false;
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: color,
                      ),
                    )),
              ],
            ))
          ],
        ),
        Transform.scale(
          scale: 1.3,
          child: Switch(
            onChanged: (v) {
              // TODO: Change enabled on device
              setState(() {
                _enabled = v;
              });

              if (v) {
                vibrate();
              }
            },
            value: _enabled,
            activeColor: color,
          ),
        ),
      ],
    );
  }

  double _bound = 132 / 323;
  Color _disabledGrey = primaryGrey.withOpacity(.75);

  @override
  Widget build(BuildContext context) {
    double _scrWidth = MediaQuery.of(context).size.width;
    double _scrHeight = MediaQuery.of(context).size.height;
    Color _accentColor = widget.accentColor ?? colorScheme[3];

    return GestureDetector(
        onLongPress: () {
          // TODO: Go to Main Edit screen.
        },
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor != null
                ? widget.backgroundColor.withOpacity(0.7)
                : colorScheme[0].withOpacity(.7),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          height: widget.height != null
              ? widget.height
              : (_scrWidth < _scrHeight)
                  ? _scrWidth * _bound + 65
                  : _scrHeight * _bound + 65,
          width: _scrWidth < _scrHeight ? _scrWidth : _scrHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: timeSection(_accentColor),
                ),
              ),
              Divider(),
              vibrationSection(_accentColor),
              volumeSection(_accentColor),
            ],
          ),
        ));
  }
}