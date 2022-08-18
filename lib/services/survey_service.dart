import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medicine_time/api.dart';

class SurveyService {

  SurveyService();

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
