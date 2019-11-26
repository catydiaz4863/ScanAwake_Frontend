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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: this.backgroundColor != null
            ? this.backgroundColor.withOpacity(0.7)
            : colorScheme[0].withOpacity(.7),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      height: height != null
          ? height
          : (MediaQuery.of(context).size.width <
                  MediaQuery.of(context).size.height)
              ? MediaQuery.of(context).size.width * (132 / 323)
              : MediaQuery.of(context).size.height * (132 / 323),
      width:
          MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      color: buttonColor != null ? buttonColor : colorScheme[3])
                  : Text('+',
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 52.5,
                          fontStyle: FontStyle.normal,
                          color: buttonColor != null
                              ? buttonColor
                              : colorScheme[3])),
            ),
            onTap: () => onPressed(),
          ),
        ],
      ),
    );
  }
}
