import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() =>  _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _reader = '';
  Permission permission = Permission.Camera;

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.pinkAccent,
      home:  Scaffold(
        appBar:  AppBar(
          title:  Text("Scanner"),
          backgroundColor: Colors.orange,
        ),
        body: Center(
          child:  Column(
            children: <Widget>[
               Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
               RaisedButton(
                splashColor: Colors.pinkAccent,
                color: Colors.red,
                child:  Text(
                  "Scan",
                  style:  TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                onPressed: scan,
              ),
               Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
               Text(
                '$_reader',
                softWrap: true,
                style:  TextStyle(fontSize: 30.0, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }

  requestPermission() async {
    var result = await SimplePermissions.requestPermission(permission);
    setState(
      () =>  SnackBar(
            backgroundColor: Colors.red,
            content:  Text(" $result"),
          ),
    );
  }

  scan() async {
    try {
      String reader = await BarcodeScanner.scan();

      if (!mounted) {
        return;
      }

      setState(() => this._reader = reader);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        requestPermission();
      } else {
        setState(() => _reader = "unknown exception $e");
      }
    } on FormatException {
      setState(() => _reader =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => _reader = 'Unknown error: $e');
    }
  }
}
