import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'lockscreen.dart';
import 'home.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isLocked;
  String pin;
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isLocked = pref.getBool('isLocked') ?? false;
    String pin = pref.getString('pin') ?? '';
    setState(() {
      this.isLocked = isLocked;
      this.pin = pin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        seconds: 1,
        navigateAfterSeconds: nextcreen(),
        title: Text("Virtual Card"),
      ),
    );
  }

  Widget nextcreen() {
    setState(() {});
    return isLocked
        ? LockScreen(isLocked: this.isLocked, pin: this.pin)
        : Home(
            isLocked: this.isLocked,
            pin: this.pin,
          );
  }
}
