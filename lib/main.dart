import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: BarcodeScannerPage(),
    );
  }
}

class BarcodeScannerPage extends StatefulWidget {
  @override
  _BarcodeScannerState createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScannerPage> {
  String barcodeFormatNote = '';
  String barcodeRawContent = '';
  BarcodeFormat barcodeFormat;
  ResultType barcodeType;

  bool isValid = false;

  Future scan() async {
    var result = await BarcodeScanner.scan();

    setState(() {
      barcodeType = result.type;
      if (barcodeType != ResultType.Barcode) {
        isValid = false;
        return;
      }

      barcodeFormatNote = result.formatNote;
      barcodeRawContent = result.rawContent;
      barcodeFormat = result.format;

      isValid = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ScanButton(
            label: 'Scan barcode/QR code',
            onPressed: scan,
          ),
          Visibility(
            visible: isValid,
            child: Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: kBorderColor,
              ),
              child: ListTile(
                leading: Icon(Icons.vpn_key),
                title: Text(
                  barcodeRawContent,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                subtitle: Text(
                  isValid ? barcodeFormat.toString() : '',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScanButton extends StatelessWidget {
  ScanButton({@required this.onPressed, @required this.label});

  final onPressed;
  final label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 64.0,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: kBorderColor,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 24.0,
            ),
          ),
        ),
      ),
    );
  }
}
