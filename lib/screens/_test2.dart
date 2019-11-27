import 'package:flutter/material.dart';
import 'package:scanawake/components/RoundedButton.dart';
import 'package:scanawake/consts.dart';

//  String label;  Color colorItem;  Color textColor;
class TestScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
          child: RoundedButton(
              label: "save",
              colorItem: colorScheme[2],
              textColor: colorScheme[0]),
        ),
        Container(
            child: RoundedButton(
          label: "cancel",
          colorItem: colorScheme[7],
          textColor: colorScheme[0],
        )),

        Container(
          child: RoundedButton(
            label: "save",
            colorItem: colorScheme[3],
            textColor: colorScheme[0],
            )
        )
      ],
    ));
  }
}
