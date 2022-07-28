import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:medicine_time/api.dart';
import 'package:medicine_time/entities/medicine_alarm.dart';
import 'package:medicine_time/entities/user.dart';

class UserSerivce {

  UserSerivce();

  // POST /
  Future<User> login(Map<String, dynamic> payload) async {
    final response = await http.post(Uri.parse(loginURL),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload));
    if (response.statusCode == 200) {
      final payload = jsonDecode(response.body);

      print(payload);

      return User.fromJson(payload as Map<String, dynamic>);
    } else {
      throw Exception('Failed to fetch items');
    }
  }
}
