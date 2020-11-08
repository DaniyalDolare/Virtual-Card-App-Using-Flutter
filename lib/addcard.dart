import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCard extends StatefulWidget {
  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  String selectedMonth = '  ';
  String selectedYear = '  ';
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController dateController;
  TextEditingController cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController =
        TextEditingController(text: selectedMonth + '/' + selectedYear);
  }

  Widget selectDate() {
    List<Widget> months = [];
    List<Widget> years = [];
    for (int i = 1; i <= 12; i++) {
      String month = i < 10 ? '0' + i.toString() : i.toString();
      months.add(Text(month));
    }
    for (int i = 0; i <= 99; i++) {
      String year = i < 10 ? '0' + i.toString() : i.toString();
      years.add(Text(year));
    }

    return Container(
      padding: EdgeInsets.all(5),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Month",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "Year",
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: CupertinoPicker(
                  children: months,
                  magnification: 1.0,
                  itemExtent: 30,
                  onSelectedItemChanged: (value) {
                    selectedMonth =
                        value < 10 ? '0' + value.toString() : value.toString();
                  },
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  children: years,
                  magnification: 1.0,
                  itemExtent: 30,
                  onSelectedItemChanged: (value) {
                    selectedYear =
                        value < 10 ? '0' + value.toString() : value.toString();
                  },
                ),
              )
            ],
          ),
        ),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            },
            child: Text("Select"))
      ]),
    );
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
                  onTap: () async {
                    await showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        context: context,
                        builder: (context) {
                          return selectDate();
                        });

                    setState(() {
                      dateController.value = TextEditingValue(
                          text: selectedMonth + "/" + selectedYear);
                    });
                  },
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
