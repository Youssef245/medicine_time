import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:medicine_time/api.dart';
import 'package:medicine_time/entities/medicine_alarm.dart';
import 'package:medicine_time/entities/question.dart';
import 'package:medicine_time/entities/side_effect.dart';
import 'package:medicine_time/entities/user.dart';
import 'package:medicine_time/entities/user_effect.dart';

class EffectsService {

  EffectsService();

  Future<List<SideEffect>> getSideEffects() async {
    final response = await http.get(Uri.parse(sideEffectsURL));

    if (response.statusCode == 200) {
      final payload = jsonDecode(response.body);

      return (payload['data'] as List)
          .map((sideEffect) => SideEffect.fromJson(sideEffect as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch items');
    }
  }

  Future<int> postEffect(Map<String, dynamic> payload) async {
    final response = await http.post(Uri.parse(userEffectsURL),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload));
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

  Future<List<UserEffect>> getEffects(int id) async {
    final response = await http.get(Uri.parse( getUserEffects(id.toString()) ) );
    if (response.statusCode == 200) {
      final payload = jsonDecode(response.body);

      return (payload['data'] as List)
          .map((effects) => UserEffect.fromJson(effects as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch items');
    }
  }

}
