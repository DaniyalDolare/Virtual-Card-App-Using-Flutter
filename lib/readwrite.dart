import 'dart:io';
import 'dart:async';
import 'cards.dart';
import 'package:path_provider/path_provider.dart';

class Storage {
  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/db.txt');
  }

  Future<List<Cards>> readData() async {
    List<Cards> cards = [];
    try {
      final file = await localFile;
      List<String> body = await file.readAsLines();

      for (String b in body) {
        List l = b.split('&');
        Cards card = new Cards(l[0], l[1], l[2], l[3]);
        cards.add(card);
      }
      return cards;
    } catch (e) {
      return cards;
    }
  }

  Future<File> writeData(List<Cards> list) async {
    final file = await localFile;
    if (file == null) {
      file.delete();
    }
    String data = '';
    for (Cards item in list) {
      data = data +
          item.name +
          '&' +
          item.number +
          '&' +
          item.date +
          '&' +
          item.csv +
          '\n';
    }
    return file.writeAsString("$data");
  }
}
