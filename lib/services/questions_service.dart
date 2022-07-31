import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:medicine_time/api.dart';
import 'package:medicine_time/entities/medicine_alarm.dart';
import 'package:medicine_time/entities/question.dart';
import 'package:medicine_time/entities/user.dart';

class QuestionsService {

  QuestionsService();

  Future<List<Question>> getQuestions(int id) async {
    final response = await http.get(Uri.parse( getQuestionsURL(id.toString()) ) );
    if (response.statusCode == 200) {
      final payload = jsonDecode(response.body);

      return (payload['data'] as List)
          .map((question) => Question.fromJson(question as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch items');
    }
  }

  Future<int> postQuestion(Map<String, dynamic> payload) async {
    final response = await http.post(Uri.parse(askURL),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload));
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

}
