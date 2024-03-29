import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:scanawake/blocs/appbloc.dart';
import 'package:scanawake/models/alarm.dart';
import 'package:scanawake/screens/mainscreen.dart';

class DisableScreen extends StatefulWidget {
  static const routeName = "/disable";
  Alarm a;
  DisableScreen(this.a);
  @override
  _DisableScreenState createState() => _DisableScreenState();
}

class _DisableScreenState extends State<DisableScreen> {
  String barcode = "";
  Future<void> check() async {
    print("starting scan");
    barcode = await FlutterBarcodeScanner.scanBarcode(
        "#6a0dad", "Cancel", true, ScanMode.BARCODE);
    print("scanned::::::::$barcode");

    setState(() {});
    print("scanned");
  }

  @override
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    AppBloc bloc = Provider.of<AppBloc>(context);

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        bloc.ringing
            ? Center(
                child: GestureDetector(
                onTap: () async {
                  await check();
                  if (barcode != "")
                    bloc.turnOffAlarm(widget.a);
                  else {
                    while (barcode == "") check();
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
                child: ClipOval(
                  child: Container(
                    color: Colors.purple,
                    height: 120.0, // height of the button
                    width: 120.0, // width of the button
                    child: Center(child: Text('Dismiss')),
                  ),
                ),
              ))
            : Text(""),
      ],
    ));
  }
}
