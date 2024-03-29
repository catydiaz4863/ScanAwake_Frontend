import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scanawake/blocs/appbloc.dart';
import 'package:scanawake/components/Seperator.dart';
import 'package:scanawake/consts.dart';
import 'package:scanawake/models/alarm.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:volume/volume.dart';

// NOTE: Currently, days are passed in/read as [true, true, false, false, false, true, false] ([Sunday, Monday, Tusday, Wednesday, Thursday, Friday, Saturday])
// TODO: FutureBuilder Based on hasVibration && hasVibrationAmplitude to know whether to use a slider with multiple amplitudes. Or just an on/off slider. (or neither)
// TODO: When wrapping time, update else. (ex. when going to one's upper/lower limit -> update other value's number...)
// TODO: Figure out how to manipulate _timeEdit values to set clock!
// TODO: Disable quick sliding in volume OR figure out how to deal with lag due to multiple awaits (sliding quickly)...

/// Card for showing editable alarm.
///
/// ```dart
/// EditableAlarmCard(enabled: true, daysEnabled: [false, true, true, true, true, true, false])
/// ```
class EditableAlarmCard extends StatefulWidget {
  EditableAlarmCard({
    Key key,
    this.alarm,
    this.backgroundColor,
    this.borderRadius = 30.0,
    this.height,
    this.onEdit,
  }) : super(key: key);

  final Alarm alarm;
  final Function onEdit;
  final Color backgroundColor;
  final double height, borderRadius;

  @override
  _EditableAlarmCardState createState() => _EditableAlarmCardState();
}

class _EditableAlarmCardState extends State<EditableAlarmCard> {
  bool _enabled, _mainView, _isSoundPlaying;
  int _maxVol, _initVol = 1;
  TimeOfDay _time;
  double _vibrateSliderVal, _volumeSliderVal;
  AudioPlayer audioPlayer;
  AudioCache playerCache;
  Alarm _alarm;

  // [hour, min_ten, min_one, am/pm]
  List<dynamic> _timeEdit = [];
  List<bool> _updateTime = [];
  List<bool> _loopingTime = [];

  @override
  void initState() {
    super.initState();
    initPlatformState(); // Should be done in root widget (so, in home?)

    _alarm = widget.alarm;
    audioPlayer = AudioPlayer();
    playerCache = AudioCache();
    _enabled = widget.alarm.enabled;
    _time = TimeOfDay(hour: widget.alarm.hour, minute: widget.alarm.minute);
    _timeEdit.add(_time.hour % 12 + 1); // Why'd I do this?
    _timeEdit
        .add(_time.minute < 10 ? 0 : int.parse(_time.minute.toString()[0]));
    _timeEdit.add(_time.minute < 10
        ? _time.minute
        : int.parse(_time.minute.toString()[1]));
    _timeEdit.add(_time.hour <= 12 ? 'AM' : 'PM');
    _mainView = true;
    _vibrateSliderVal = widget.alarm.vibrationLevel;
    _volumeSliderVal = widget.alarm.soundLevel;
    _isSoundPlaying = false;
    _updateTime = [false, false, false, false];
    _loopingTime = [false, false, false, false];
  }

  Future<void> initPlatformState() async {
    // audioplayer is currently using media/music.
    Volume.controlVolume(AudioManager.STREAM_MUSIC);

    // setState(() async {
    //   _maxVol = await Volume.getMaxVol;
    // });
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

  // Volume Slider blop.
  testVolume() async {
    setState(() {
      _isSoundPlaying = true;
    });

    playerCache.load('mp3/bad_custom_notif.mp3');

    Volume.setVol(_volumeSliderVal.floor());

    audioPlayer = await playerCache.play("mp3/bad_custom_notif.mp3", volume: 1);

    setState(() {
      _isSoundPlaying = false;
    });
  }

  updateAMPM() async {
    if (_loopingTime[3]) return;

    _loopingTime[3] = true;

    while (_updateTime[3]) {
      setState(() {
        _timeEdit[3] = _timeEdit[3] == 'AM' ? 'PM' : 'AM';
        _alarm.hour = (_alarm.hour + 12) % 24; // TODO: FIX?
      });

      await Future.delayed(Duration(milliseconds: 225));
    }

    widget.onEdit(_alarm);
    _loopingTime[3] = false;
  }

  updateMinTen({pos: true}) async {
    if (_loopingTime[1]) return;

    _loopingTime[1] = true;

    while (_updateTime[1]) {
      if (pos) {
        int val = _timeEdit[1] % 6 + 1;

        setState(() {
          _timeEdit[1] = val == 6 ? 0 : val;
        });
      } else {
        setState(() {
          _timeEdit[1] = (_timeEdit[1] - 1) % 6;
        });
      }

      _alarm.minute = int.parse('${_timeEdit[1]}${_timeEdit[2]}');
      setState(() {});
      widget.onEdit(_alarm);

      await Future.delayed(Duration(milliseconds: 225));
    }

    _loopingTime[1] = false;
  }

  updateMinOne({pos: true}) async {
    if (_loopingTime[2]) return;

    _loopingTime[2] = true;

    while (_updateTime[2]) {
      if (pos) {
        int val = _timeEdit[2] % 10 + 1;

        setState(() {
          _timeEdit[2] = val == 10 ? 0 : val;
        });
      } else {
        setState(() {
          _timeEdit[2] = (_timeEdit[2] - 1) % 10;
        });
      }

      _alarm.minute = int.parse('${_timeEdit[1]}${_timeEdit[2]}');
      setState(() {});
      widget.onEdit(_alarm);

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
          _timeEdit[0] = (_timeEdit[0] % 12) + 1;
        });
      } else {
        int val = (_timeEdit[0] - 1) % 12;

        setState(() {
          _timeEdit[0] = val == 0 ? 12 : val;
        });
      }

      _alarm.hour =
          _alarm.hour > 12 ? (_timeEdit[0] + 12 - 1) : _timeEdit[0] - 1;
      setState(() {});
      widget.onEdit(_alarm);

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

                  _alarm.vibrationLevel = v;
                  widget.onEdit(_alarm);
                  vibrate();
                },
                divisions: 10,
              ))
        ],
      ),
    );
  }

  Widget volumeSection(Color color) {
    if (_maxVol == null) {
      return FutureBuilder(
        future: Volume.getMaxVol,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return CircularProgressIndicator();
              break;
            case ConnectionState.done:
              _maxVol = snapshot.data;

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
                                  color: _enabled
                                      ? colorScheme[6]
                                      : _disabledGrey),
                            ))),
                    Container(
                        height: 37.5,
                        child: Slider(
                          min: 0.0,
                          max: _maxVol.toDouble(),
                          value: _volumeSliderVal,
                          activeColor: _enabled ? color : _disabledGrey,
                          inactiveColor: _disabledGrey.withOpacity(.25),
                          onChanged: _isSoundPlaying
                              ? null
                              : (v) async {
                                  setState(() {
                                    _volumeSliderVal = v;
                                  });

                                  _alarm.soundLevel = v;
                                  widget.onEdit(_alarm);
                                  testVolume();
                                },
                          divisions: _maxVol,
                        ))
                  ],
                ),
              );
              break;
            default:
          }
          return CircularProgressIndicator();
        },
      );
    } else {
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
                  max: _maxVol.toDouble(),
                  value: _volumeSliderVal,
                  activeColor: _enabled ? color : _disabledGrey,
                  inactiveColor: _disabledGrey.withOpacity(.25),
                  onChanged: _isSoundPlaying
                      ? null
                      : (v) async {
                          setState(() {
                            _volumeSliderVal = v;
                          });

                          _alarm.soundLevel = v;
                          widget.onEdit(_alarm);
                          testVolume();
                        },
                  divisions: _maxVol,
                ))
          ],
        ),
      );
    }
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
                          text: _timeEdit[0] >= 10
                              ? '${_timeEdit[0].toString()[0]} '
                              : '${_timeEdit[0]}',
                        ),
                        TextSpan(
                            text: _timeEdit[0] < 10
                                ? ''
                                : '${_timeEdit[0].toString()[1]}'),
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
                      '${_timeEdit[1]}',
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
                      "${_timeEdit[2]}",
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
                    "${_timeEdit[3]}",
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

              // TODO: Mess with timers...
              _alarm.enabled = v;
              widget.onEdit(_alarm);

              if (v) {
                vibrate();
                testVolume();
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
    AppBloc bloc = Provider.of<AppBloc>(context);

    double _scrWidth = MediaQuery.of(context).size.width;
    double _scrHeight = MediaQuery.of(context).size.height;
    Color _accentColor = bloc.appColor;

    return Container(
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
          Divider(thickness: .65),
          vibrationSection(_accentColor),
          volumeSection(_accentColor),
        ],
      ),
    );
  }
}
