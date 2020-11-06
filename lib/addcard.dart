import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'strings.dart';
//import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class AddCard extends StatefulWidget {
  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final dateController = TextEditingController();
  final cvvController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateController.value = TextEditingValue(text: picked.toString());
      });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    numberController.dispose();
    dateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  void saveCard(List<String> data) {
    Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Add Card Details",
          textDirection: TextDirection.ltr,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: <Widget>[
          Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 4)),
              Text(
                'All fields are mandatory*',
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 35.0, 8.0, 8.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: new InputDecoration(hintText: "Enter card name"),
                  maxLength: 30,
                  keyboardType: TextInputType.name,
                ),
                TextField(
                  controller: numberController,
                  decoration:
                      new InputDecoration(hintText: "Enter card number"),
                  maxLength: 16,
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: dateController,
                  decoration:
                      new InputDecoration(hintText: "Enter expiry date(mm/yy)"),
                  maxLength: 5,
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  controller: cvvController,
                  decoration: new InputDecoration(hintText: "Enter cvv"),
                  maxLength: 3,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                ),
                Padding(padding: EdgeInsets.only(top: 100)),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        numberController.text.length < 16 ||
                        dateController.text.length < 5 ||
                        cvvController.text.length < 3) {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) => AlertDialog(
                                elevation: 20,
                                title: Text((numberController.text.length < 16)
                                    ? "Card number must be of 16 digits"
                                    : (cvvController.text.length < 3)
                                        ? "CVV must be of 3 digits"
                                        : "All feilds must be properly filled!"),
                                //Text("All fields must be filled properly"),
                                actions: [
                                  FlatButton(
                                    child: Text("OK"),
                                    splashColor: Colors.blueAccent,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ));
                    } else {
                      final List<String> data = [
                        nameController.text,
                        numberController.text,
                        dateController.text,
                        cvvController.text,
                      ];
                      saveCard(data);
                    }
                  },
                  child: Text(
                    "Save",
                    textDirection: TextDirection.ltr,
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
