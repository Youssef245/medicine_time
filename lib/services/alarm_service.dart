import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:medicine_time/api.dart';
import 'package:medicine_time/entities/medicine_alarm.dart';

class AlarmService {

  AlarmService();

  // POST /
  Future<int> createAlarm(Map<String, dynamic> payload) async {
    final response = await http.post(Uri.parse(alarmsURL),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload));
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
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
