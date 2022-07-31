import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:medicine_time/api.dart';
import 'package:medicine_time/entities/medicine_alarm.dart';
import 'package:medicine_time/entities/question.dart';
import 'package:medicine_time/entities/user.dart';

class SurveySerive {

  SurveySerive();

  Future<int> postSurvey(Map<String, dynamic> payload) async {
    final response = await http.post(Uri.parse(surveyURL),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload));
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

}
