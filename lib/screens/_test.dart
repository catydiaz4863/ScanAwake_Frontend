import 'package:flutter/material.dart';
import 'package:scanawake/components/AddAlarmCard.dart';
import 'package:scanawake/components/AlarmCard.dart';
import 'package:scanawake/components/RoundedButton.dart';
import 'package:scanawake/components/RoundedInput.dart';
import 'package:scanawake/consts.dart';

/// Test Screen
/// Simple screen meant for testing assets/components.
class TestScreen extends StatelessWidget {
  const TestScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: AlarmCard(
                daysEnabled: [false, false, true, false, true, false, false],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: AlarmCard(
                accentColor: primaryPurple,
                daysEnabled: [false, true, true, true, true, true, false],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: AddAlarmCard(
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
