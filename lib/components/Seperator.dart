import 'package:flutter/material.dart';
import 'package:scanawake/consts.dart';

class Seperator extends StatelessWidget {
  const Seperator(
      {Key key,
      this.text = '',
      this.color,
      this.margin = const EdgeInsets.symmetric(horizontal: 25),
      this.thiccness = 0.5})
      : super(key: key);
  final String text;
  final double thiccness;
  final EdgeInsets margin;
  final Color color;

  Widget line(width) {
    return Container(
      height: thiccness,
      width: width,
      color: color ?? colorScheme[3],
    );
  }

  Widget seperate(width) {
    if (text.isEmpty) {
      return line(width);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        line(width / 3),
        Container(
          child: Text(text, style: subtleText.apply(color: primaryGrey)),
          margin: margin,
        ),
        line(width / 3)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: seperate(MediaQuery.of(context).size.width),
      margin: margin,
    );
  }
}
