import 'package:flutter/material.dart';
import 'package:scanawake/consts.dart';

// TODO: Remove splash animation on focus/click...

/// Stylized app input wrapped around a TextField.
///
/// ```dart
/// RoundedInput(textController: passwdController, obscureText: true, hintText: 'Enter password...', width: MediaQuery.of(context).size.width * 0.75)
/// ```
class RoundedInput extends StatelessWidget {
  const RoundedInput({
    Key key,
    this.txtCtrl,
    this.width,
    this.obscureText = false,
    this.hintText = '',
    this.borderColor,
    this.focusNode,
    this.borderRadius = 50.0,
  }) : super(key: key);

  final TextEditingController txtCtrl;
  final double width, borderRadius;
  final bool obscureText;
  final String hintText;
  final Color borderColor;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        child: TextField(
          autocorrect: false,
          decoration: new InputDecoration(
              fillColor: colorScheme[0],
              filled: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 22, vertical: 13.5),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1,
                    color: borderColor != null ? borderColor : colorScheme[4]),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1,
                    color: borderColor != null ? borderColor : colorScheme[4]),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: borderColor != null ? borderColor : colorScheme[4]),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              hintText: hintText,
              hintStyle: subtleText.apply(color: Color(0xFF848484))),
          cursorColor: colorScheme[4],
          cursorRadius: Radius.circular(borderRadius),
          controller: txtCtrl,
          obscureText: obscureText,
          style: subtleText.apply(fontSizeFactor: 1.1),
        ));
  }
}
