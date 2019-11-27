import 'package:flutter/material.dart';
import 'package:scanawake/consts.dart';

// TODO: Add/Enable splashEffect/touch feedback on InkWell.
// NOTE: Using InkWell instead of Flat/MaterialButton due to phantom padding messing with it.

/// Card for adding alarms
///
/// ```dart
/// AddAlarmCard(onPressed: () {}, needPremium: true)
/// ```
class AddAlarmCard extends StatelessWidget {
  const AddAlarmCard(
      {Key key,
      this.height,
      this.buttonColor,
      this.backgroundColor,
      this.borderRadius = 30.0,
      this.onPressed,
      this.needPremium = false})
      : super(key: key);
  final double height, borderRadius;
  final Color buttonColor, backgroundColor;
  final Function onPressed;
  final bool needPremium;

  @override
  Widget build(BuildContext context) {
    double _scrWidth = MediaQuery.of(context).size.width;
    double _scrHeight = MediaQuery.of(context).size.height;
    double _bound = 132/323;
    Color _buttonColor = buttonColor ?? colorScheme[3];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: this.backgroundColor != null
            ? this.backgroundColor.withOpacity(0.7)
            : colorScheme[0].withOpacity(.7),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      height: height ?? (_scrWidth < _scrHeight)
          ? _scrWidth * _bound
          : _scrHeight * _bound,
      width: _scrWidth < _scrHeight ? _scrWidth : _scrHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Text(
              needPremium
                  ? 'Join Premium To Add More Alarms!'
                  : 'Add New Alarm',
              style: needPremium
                  ? smSectionText.apply(color: colorScheme[4])
                  : smSectionText.apply(color: primaryGrey),
            ),
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(2.5),
              child: needPremium
                  ? Icon(Icons.chevron_right,
                      size: 52.5,
                      color: _buttonColor)
                  : Text('+',
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 52.5,
                          fontStyle: FontStyle.normal,
                          color: _buttonColor)),
            ),
            onTap: () => onPressed(),
          ),
        ],
      ),
    );
  }
}
