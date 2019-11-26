import 'package:flutter/material.dart';
import 'package:scanawake/consts.dart';

// TODO: Add/Enable splashEffect/touch feedback on InkWell.
// NOTE: Using InkWell instead of Flat/MaterialButton due to phantom padding messing with it.

class AddAlarmCard extends StatelessWidget {
  const AddAlarmCard(
      {Key key,
      this.height,
      this.buttonColor,
      this.backgroundColor,
      this.borderRadius = 30.0,
      this.onPressed})
      : super(key: key);
  final double height, borderRadius;
  final Color buttonColor, backgroundColor;
  final Function onPressed;

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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            'Add New Alarm',
            style: smSectionText.apply(color: primaryGrey),
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(2.5),
              child: Text('+',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 52.5,
                      fontStyle: FontStyle.normal,
                      color:
                          buttonColor != null ? buttonColor : colorScheme[3])),
            ),
            onTap: () => onPressed(),
          ),
        ],
      ),
    );
  }
}
