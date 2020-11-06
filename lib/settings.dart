import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsPage extends StatefulWidget {
  final bool isLocked;
  final String pin;
  SettingsPage({Key key, this.isLocked, this.pin}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController newPin = TextEditingController();
  bool isLocked;
  String pin;
  bool toggled = false;

  void initState() {
    super.initState();
    this.isLocked = this.widget.isLocked;
    this.pin = this.widget.pin;
  }

  @override
  void dispose() {
    super.dispose();
    newPin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (toggled) {
          Fluttertoast.showToast(
            msg: 'Pin cannot be empty',
            textColor: Colors.black,
            backgroundColor: Colors.grey[200],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
        return toggled
            ? !this.isLocked
            : this.widget.isLocked
                ? true
                : true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Settings'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Add Lock',
                        style: TextStyle(fontSize: 20),
                      ),
                      Switch(
                          value: this.isLocked,
                          onChanged: (value) {
                            setState(() {
                              this.isLocked = value;
                              toggled = value;
                              setIsLocked(this.isLocked);
                            });
                          })
                    ],
                  ),
                  this.toggled
                      ? Column(
                          children: <Widget>[
                            TextField(
                              controller: newPin,
                              decoration:
                                  InputDecoration(hintText: 'Enter pin'),
                              maxLength: 4,
                              keyboardType: TextInputType.number,
                            ),
                            FlatButton(
                                onPressed: () {
                                  newPin.text.length < 4
                                      ? showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                                'Pin must be of 4 digits only'),
                                            actions: [
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Ok'),
                                                splashColor: Colors.blue[100],
                                              )
                                            ],
                                          ),
                                        )
                                      : savePin(newPin.text);
                                },
                                child: Text('Save'),
                                textColor: Colors.white,
                                color: Colors.blue,
                                splashColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ))
                          ],
                        )
                      : Container(),
                ]),
                Text('© Virtual Card v1.0')
              ]),
        ),
      ),
    );
  }

  Future<void> savePin(String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('pin', value);
    Navigator.pop(context);
  }

  Future<void> setIsLocked(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isLocked', value);
  }
}
