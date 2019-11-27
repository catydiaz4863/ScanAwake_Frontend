import 'package:flutter/material.dart';
import 'package:scanawake/blocs/appbloc.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _widgetOptions = <Widget>[

    ];
  }

  @override
  Widget build(BuildContext context) {
    AppBloc bloc = Provider.of<AppBloc>(context);

    // TODO: Decide on using BottomAppBar or just straight to home.
    // Mainly beacuse we're not using our own backend meaning no reason for profile, so I don't know
    //  about needing only a 1 or 2-button appbar.
    return Scaffold(
    body: SafeArea(child: Container(),)
    );
  }
}