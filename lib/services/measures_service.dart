import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:medicine_time/api.dart';

class MeasuresService {

  MeasuresService();

  // POST /
  Future<int> addMeasure(Map<String, dynamic> payload) async {
    final response = await http.post(Uri.parse(measuresURL),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload));
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

}
