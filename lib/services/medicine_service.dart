import 'dart:convert';

import 'package:medicine_time/api.dart';
import 'package:http/http.dart' as http;
import 'package:medicine_time/entities/medicine.dart';

class MedicineService {


  Future<List<Medicine>> getMedicines() async {
    final response = await http.get(Uri.parse(medicinesURL));

    if (response.statusCode == 200) {
      final payload = jsonDecode(response.body);

      return (payload['data'] as List)
          .map((medicine) => Medicine.fromJson(medicine as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch items');
    }
  }

  Future<List<MedCategory>> getCategories() async {
    final response = await http.get(Uri.parse(categoriesURL));

    if (response.statusCode == 200) {
      final payload = jsonDecode(response.body);

      return (payload['data'] as List)
          .map((category) => MedCategory.fromJson(category as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch items');
    }
  }
}

class MedCategory {
  String? name;

  MedCategory(this.name);

  factory MedCategory.fromJson(Map<String, dynamic> json) {
    return MedCategory(
        json['cat_name']
    );
  }
}