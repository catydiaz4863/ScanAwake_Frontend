import 'dart:async';
import 'dart:io';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';

class BarcodeScreen extends StatefulWidget {
  BuildContext mainPageCT;
  BarcodeScreen(this.mainPageCT);

  @override
  _BarcodeScreenState createState() => new _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  String barcode = "";


  @override
  initState() {
    super.initState();
  }

  void check() async {
    print("starting scan");
    barcode = await FlutterBarcodeScanner.scanBarcode(
        "#6a0dad", "Cancel", true, ScanMode.BARCODE);
    print("scanned::::::::$barcode");

    setState(() {});
    print("scanned");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Scan Barcode'),
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new Container(
              child: new RaisedButton(
                  onPressed: check, child: new Text("Capture image")),
              padding: const EdgeInsets.all(8.0),
            ),
            new Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            new Text("Barcode Number after Scan : " + "$barcode"),
            // displayImage(),
          ],
        ),
      ),
    );
  }
}
