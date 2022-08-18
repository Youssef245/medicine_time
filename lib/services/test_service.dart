import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medicine_time/api.dart';

class TestService {

  TestService();

  Future<int> postTest1(Map<String, dynamic> payload) async {
    final response = await http.post(Uri.parse(test1URL),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload));
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

  Future<int> postTest2(Map<String, dynamic> payload) async {
    final response = await http.post(Uri.parse(test2URL),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload));
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

  Future<int> postTest3(Map<String, dynamic> payload) async {
    final response = await http.post(Uri.parse(test3URL),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload));
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

}
