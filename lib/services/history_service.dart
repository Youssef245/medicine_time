import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:medicine_time/api.dart';
import 'package:medicine_time/entities/medicine_alarm.dart';

class HistoryService {

  HistoryService();

  // POST /
  Future<int> createHistory(Map<String, dynamic> payload) async {
    final response = await http.post(Uri.parse(historyURL),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload));
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

}
