import 'package:flutter/material.dart';


/// Rounded Button
/// Default button type of app buttons.
///
/// Can be used as "SemiRounded Button" as well.
class RoundedButton extends StatelessWidget {
  
  final TextEditingController txtCtrl;
  final String label;
  final Color colorItem;
  final Color textColor;
  const RoundedButton( {
    Key key,
    this.txtCtrl,
    this.label,
    this.colorItem,
    this.textColor,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
     child: RaisedButton(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0),
          ),
          onPressed: () {},
          color: colorItem,
          textColor: textColor,
          child: Text(label.toUpperCase(), style: TextStyle(fontSize: 14)),
        )
    );
  }
}