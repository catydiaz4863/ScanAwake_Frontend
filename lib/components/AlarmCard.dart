import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scanawake/components/Seperator.dart';
import 'package:scanawake/consts.dart';

// NOTE: Currently, days are passed in/read as [true, true, false, false, false, true, false] ([Sunday, Monday, Tusday, Wednesday, Thursday, Friday, Saturday])

/// Card for showing alarm in the main screen.
///
/// ```dart
/// AlarmCard(enabled: true, daysEnabled: [false, true, true, true, true, true, false])
/// ```
class AlarmCard extends StatefulWidget {
  AlarmCard(
      {Key key,
      this.alarmId,
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
  final double height, borderRadius;

  @override
  _AlarmCardState createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  bool _enabled, _mainView;
  TimeOfDay _time;
  List<bool> _daysEnabled;

  @override
  void initState() {
    super.initState();

    _enabled = widget.enabled;
    _time = widget.time == null ? new TimeOfDay.now() : widget.time;
    _daysEnabled = widget.daysEnabled;
    _mainView = true;
  }

  Widget frequencySection(Color color) {
    return Container(
      child: Column(
        children: <Widget>[
          Seperator(
            thiccness: .75,
            color: _enabled ? color : _disabledGrey,
          ),
          Container(
            height: 37.5,
            child: ListView.builder(
              physics: new BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.5, vertical: 2),
                  child: Container(
                    width: 40,
                    child: InkWell(
                        onLongPress: () {
                          // TODO: Make it reflect changes on whatever we store it in. (Not just visually)

                          setState(() {
                            _daysEnabled[index] = !_daysEnabled[index];
                          });

                          Fluttertoast.showToast(
                              msg:
                                  "${_daysEnabled[index] ? 'Enabled' : 'Disabled'} alarm's ${days[index].last} repeat.",
                              fontSize: 14.5,
                              timeInSecForIos: 1,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: color,
                              textColor: colorScheme[0]);
                        },
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              days[index].first,
                              textAlign: TextAlign.center,
                              style: subtleText.apply(
                                  fontWeightDelta: _daysEnabled[index] ? 2 : 1,
                                  color: _enabled
                                      ? (_daysEnabled[index]
                                          ? color
                                          : _disabledGrey)
                                      : (_daysEnabled[index]
                                          ? primaryGrey.withOpacity(.7)
                                          : _disabledGrey.withOpacity(.6))),
                            ))),
                  ),
                );
              },
              itemCount: 7,
              scrollDirection: Axis.horizontal,
            ),
          )
        ],
      ),
    );
  }

  Widget timeSection(Color color) {
    //String hourString = time;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          '${(_time.hour < 10) ? _time.hour : (_time.hour.toString()[0] + ' ' + _time.hour.toString()[1])} : ${_time.minute < 10 ? '0' : _time.minute.toString()[0]} ${_time.minute < 10 ? _time.minute.toString()[0] : _time.minute.toString()[1]} ${_time.hour > 12 ? 'PM' : 'AM'}',
          style: sectionText.apply(
              color: _enabled ? colorScheme[6] : _disabledGrey),
        ),
        Transform.scale(
          scale: 1.3,
          child: Switch(
            onChanged: (v) {
              // TODO: Change enabled on device
              setState(() {
                _enabled = v;
              });
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
    print('enabled? $_enabled');
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
                  ? _scrWidth * _bound
                  : _scrHeight * _bound,
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
              frequencySection(_accentColor),
            ],
          ),
        ));
  }
}
