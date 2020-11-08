import 'package:flutter/material.dart';
import 'cards.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCode extends StatelessWidget {
  final Cards data;
  QRCode({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context, false),
          icon: Icon(Icons.keyboard_arrow_left),
        ),
        titleSpacing: -10.0,
        title: Text(this.data.name),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                QrImage(
                  data: this.data.name.toString() +
                      ' ' +
                      this.data.number.toString(),
                  version: QrVersions.auto,
                  size: 300.0,
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 25, 0, 25)),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.blue,
                  disabledColor: Colors.grey,
                  splashColor: Colors.blueAccent,
                  textColor: Colors.white,
                  child: Text('Delete'),
                  onPressed: () => {
                    Navigator.pop(context, true),
                  },
                )
              ]),
        ),
      ),
    );
  }
}
