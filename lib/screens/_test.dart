import 'package:flutter/material.dart';
import 'package:scanawake/components/RoundedInput.dart';

/// Test Screen
/// Simple screen meant for testing assets/components.
class TestScreen extends StatelessWidget {
  const TestScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: RoundedInput(
              hintText: 'Enter your email',
              txtCtrl: new TextEditingController(),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: RoundedInput(
                hintText: 'Password',
                obscureText: true,
                txtCtrl: new TextEditingController(),
              )),
        ],
      ),
    );
  }
}
