import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cards.dart';
import 'addcard.dart';
import 'savedcards.dart';
import 'readwrite.dart';
import 'strings.dart';
import 'package:app/readwrite.dart';
import 'settings.dart';

class Home extends StatefulWidget {
  final bool isLocked;
  final String pin;

  Home({Key key, this.isLocked, this.pin}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Storage storage = Storage();
  List<Cards> cards = [];
  List<Cards> card;
  bool isAuthenticated = false;
  bool isLocked;
  String pin;

  @override
  void initState() {
    super.initState();
    isLocked = widget.isLocked;
    pin = widget.pin;
    this.storage.readData().then((var card) {
      setState(() {
        this.cards = card;
      });
    });
  }

  Future<void> setData(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isLocked', value);
    setState(() {
      this.isLocked = pref.getBool('isLocked');
    });
  }

  Future<void> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    this.isLocked = pref.getBool('isLocked') ?? false;
    this.pin = pref.getString('pin');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: Strings.appBarTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: cards.isEmpty
            ? Scaffold(
                appBar: AppBar(
                  title: Text(Strings.appBarTitle),
                  actions: [
                    IconButton(
                        onPressed: () {
                          openSetting();
                        },
                        icon: Icon(
                          Icons.settings,
                        ))
                  ],
                ),
                body: Center(
                  child: Text(
                    "Add a card",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    _awaitReturnValueFromAddCard(context);
                  },
                  child: Icon(Icons.add, size: 35, color: Colors.white),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text(Strings.appBarTitle),
                  actions: [
                    IconButton(
                        onPressed: () {
                          openSetting();
                        },
                        icon: Icon(
                          Icons.settings,
                        ))
                  ],
                ),
                body: SavedCards(storage: Storage(), listItems: this.cards),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    _awaitReturnValueFromAddCard(context);
                  },
                  child: Icon(Icons.add, size: 35, color: Colors.white),
                ),
              ));
  }

  void openSetting() async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            SettingsPage(isLocked: this.isLocked, pin: this.pin)));
    setState(() {
      getData();
    });
  }

  void _awaitReturnValueFromAddCard(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final List<String> result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddCard(),
        ));

    // after the SecondScreen result comes back update the screen with new card
    if (result != null) {
      setState(() {
        cards.add(new Cards(result[0], result[1], result[2], result[3]));
        writeData();
      });
    }
  }

  Future<File> writeData() async {
    return this.storage.writeData(this.cards);
  }
}
