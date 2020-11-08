import 'dart:io';
import 'package:flutter/rendering.dart';
import 'readwrite.dart';
import 'package:flutter/material.dart';
import 'cards.dart';
import 'qrcode.dart';

class SavedCards extends StatefulWidget {
  final List<Cards> listItems;
  final Storage storage;
  SavedCards({Key key, @required this.storage, this.listItems})
      : super(key: key);

  @override
  _SavedCardsState createState() => _SavedCardsState();
}

class _SavedCardsState extends State<SavedCards> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.widget.listItems.length,
      itemBuilder: (context, index) {
        var card = this.widget.listItems[index];
        return Padding(
          padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue,
            child: InkWell(
              splashColor: Colors.blue[100],
              child: Container(
                child: ListTile(
                  title: Text(
                    card.name,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  subtitle: Text(
                    card.number.substring(0, 4) +
                        " XXXX XXXX " +
                        card.number.substring(12, 16),
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              onTap: () {
                _awaitReturnValueFromQRCode(context, card);
              },
            ),
          ),
        );
      },
    );
  }

  void _awaitReturnValueFromQRCode(BuildContext context, card) async {
    final bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRCode(data: card),
        ));

    setState(() {
      if (result == true) {
        this.widget.listItems.remove(card);
        writeData();
      }
    });
  }

  Future<File> writeData() async {
    return widget.storage.writeData(this.widget.listItems);
  }
}
