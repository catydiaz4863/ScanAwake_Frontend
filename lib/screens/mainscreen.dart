import 'package:flutter/material.dart';
import 'package:scanawake/blocs/appbloc.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    AppBloc bloc = Provider.of<AppBloc>(context);

    return Scaffold(
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
       //its going to return alarm cards
       
      ],
    )
          
    );
  }
}