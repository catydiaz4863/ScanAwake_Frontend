import 'package:flutter/material.dart';
import 'package:scanawake/consts.dart';

/// Rounded Button
/// Default button type of app buttons.
///
/// Can be used as "SemiRounded Button" as well.
///
/// ```dart
/// RoundedButton(onPressed: () {}, text: 'Submit')
/// ```
class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {Key key,
      this.onPressed,
      this.width,
      this.height,
      this.text = 'Text',
      this.buttonColor,
      this.textColor,
      this.borderRadius = 50.0,
      this.focusNode})
      : super(key: key);
  final Function onPressed;
  final String text;
  final double width, height, borderRadius;
  final Color buttonColor, textColor;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width != null ? width : MediaQuery.of(context).size.width,
        child: FlatButton(
          focusNode: focusNode,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          padding: EdgeInsets.all(12),
          onPressed: onPressed,
          disabledColor: Colors.grey,
          color: buttonColor != null ? buttonColor : const Color(0xFF0085FF),
          child: Text(
            text,
            style: boldText.apply(
                color: textColor != null ? textColor : colorScheme[0]),
          ),
        ));
  }
}
