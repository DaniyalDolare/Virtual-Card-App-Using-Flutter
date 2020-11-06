import 'dart:io';
import 'package:app/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LockScreen extends StatefulWidget {
  final String pin;
  final bool isLocked;
  LockScreen({Key key, this.isLocked, this.pin}) : super(key: key);
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  List enteredPin = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait
                ? _buildPortraitLockScreen()
                : _buildLandscapeLockScreen();
          },
        ),
      ),
    );
  }

  _buildPortraitLockScreen() => Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Enter Pin",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildCirle(enteredPin.length >= 1 ? true : false),
                buildCirle(enteredPin.length >= 2 ? true : false),
                buildCirle(enteredPin.length >= 3 ? true : false),
                buildCirle(enteredPin.length >= 4 ? true : false)
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildKeyboardDigit('1'),
              buildKeyboardDigit('2'),
              buildKeyboardDigit('3'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildKeyboardDigit('4'),
              buildKeyboardDigit('5'),
              buildKeyboardDigit('6'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildKeyboardDigit('7'),
              buildKeyboardDigit('8'),
              buildKeyboardDigit('9'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [buildKeyboardDigit('0')],
          ),
          Row(
            children: [
              Expanded(
                child: Container(),
              ),
              Expanded(
                child: FlatButton(
                    onPressed: () {
                      deleteNum(enteredPin.isEmpty ? 'Cancel' : 'Delete');
                    },
                    child: Text(enteredPin.isEmpty ? 'Cancel' : 'Delete',
                        style: TextStyle(color: Colors.white, fontSize: 14))),
              )
            ],
          ),
        ],
      );

  _buildLandscapeLockScreen() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter Pin",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCirle(enteredPin.length >= 1 ? true : false),
                  buildCirle(enteredPin.length >= 2 ? true : false),
                  buildCirle(enteredPin.length >= 3 ? true : false),
                  buildCirle(enteredPin.length >= 4 ? true : false)
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildKeyboardDigit('1'),
                  buildKeyboardDigit('2'),
                  buildKeyboardDigit('3'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildKeyboardDigit('4'),
                  buildKeyboardDigit('5'),
                  buildKeyboardDigit('6'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildKeyboardDigit('7'),
                  buildKeyboardDigit('8'),
                  buildKeyboardDigit('9'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [buildKeyboardDigit('0')],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: FlatButton(
                    onPressed: () {
                      deleteNum(enteredPin.isEmpty ? 'Cancel' : 'Delete');
                    },
                    child: Text(enteredPin.isEmpty ? 'Cancel' : 'Delete',
                        style: TextStyle(color: Colors.white, fontSize: 14))),
              )
            ],
          ),
        ],
      );

  Widget buildCirle(bool fill) {
    return Container(
        margin: EdgeInsets.all(4),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: fill ? Colors.white : Colors.transparent,
            border: Border.all(color: Colors.white, width: 1)));
  }

  Widget buildKeyboardDigit(String text) {
    return Container(
      margin: EdgeInsets.all(10),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              getNumPressed(text);
            },
            splashColor: Colors.white,
            child: Container(
                width: 75,
                height: 75,
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(color: Colors.white, width: 1))),
          ),
        ),
      ),
    );
  }

  getNumPressed(String text) {
    enteredPin.add(text);
    setState(() {
      print('${enteredPin.join()},${this.widget.pin}');

      if (enteredPin.join() == this.widget.pin) {
        print('yes');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                    isLocked: this.widget.isLocked, pin: this.widget.pin)));
      }
    });
    if (enteredPin.length == 4) {
      refresh();
    }
  }

  refresh() {
    sleep(Duration(milliseconds: 150));
    enteredPin = [];
    setState(() {});
  }

  deleteNum(String value) {
    if (value == 'Delete') {
      enteredPin.removeLast();
      setState(() {});
    } else {
      SystemNavigator.pop();
    }
  }
}
