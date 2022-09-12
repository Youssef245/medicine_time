import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medicine_time/api.dart';
import 'package:medicine_time/entities/history.dart';
import '../LocalDB.dart';

class HistoryService {

  HistoryService();
  LocalDB dbHelper = LocalDB();

  // POST /
  Future<void> createHistory(History history) async {
    try{
      final response = await http.post(Uri.parse(historyURL),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(history.toJson()));

      switch (response.statusCode) {
        case 200:
        case 201:
          print("Success");
          break;
        case 400:
        case 401:
        case 500:
        case 501:
        case 502:
          await dbHelper.createOfflineHistory(history);
          break;
      }
    } on SocketException{
      await dbHelper.createOfflineHistory(history);
    } on FormatException {
      await dbHelper.createOfflineHistory(history);
    } on HttpException {
      await dbHelper.createOfflineHistory(history);
    }
  }

}
