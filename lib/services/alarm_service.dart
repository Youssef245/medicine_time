import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medicine_time/LocalDB.dart';
import 'package:medicine_time/api.dart';
import 'package:medicine_time/entities/medicine_alarm.dart';

class AlarmService {

  LocalDB dbHelper = LocalDB();

  AlarmService();

  // POST /
  Future<void> createAlarm(MedicineAlarm alarm) async {
    try{
      final response = await http.post(Uri.parse(alarmsURL),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(alarm.toJson()));
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
          await dbHelper.createOfflineAlarm(alarm);
          break;
      }
    } on SocketException{
      await dbHelper.createOfflineAlarm(alarm);
    } on FormatException {
      await dbHelper.createOfflineAlarm(alarm);
    } on HttpException {
      await dbHelper.createOfflineAlarm(alarm);
    }
  }

  Future<int> getLastID() async {
    final response = await http.get(Uri.parse(lastAlarmURL));

    if (response.statusCode == 200) {
      final payload = jsonDecode(response.body);

      print(response.statusCode);

      return payload['id'];
    } else {
      throw Exception('Failed to fetch items');
    }
  }

  Future deleteAlarm (MedicineAlarm alarm) async {
    final response = await http.delete(Uri.parse(deleteAlarmURL(alarm.alarmId.toString())));
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }
}
