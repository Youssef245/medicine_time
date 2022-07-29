import 'dart:ffi';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Measure {
  String? pressure ;
  double? glucose ;
  double? random_glucose ;
  double? sodium ;
  double? potassium ;
  double? phosphate ;
  double? createnin ;
  double? hemoglobin ;
  double? weight ;
  int? user_id ;
  String? inserted_date ;
  double? calcium ;
  double? range ;

  Measure();


  Measure.name(
      this.pressure,
      this.glucose,
      this.random_glucose,
      this.sodium,
      this.potassium,
      this.phosphate,
      this.createnin,
      this.hemoglobin,
      this.weight,
      this.user_id,
      this.inserted_date,
      this.calcium,
      this.range);


  Measure.name2(
      this.pressure,
      this.glucose,
      this.random_glucose,
      this.sodium,
      this.potassium,
      this.phosphate,
      this.createnin,
      this.hemoglobin,
      this.weight,
      this.inserted_date,
      this.calcium,
      this.range);

  factory Measure.fromJson(Map<String, dynamic> json) {
    return Measure.name2(
      json["pressure"],
      json["glucose"],
      json["random_glucose"],
      json["sodium"],
      json["potassium"],
      json["phosphate"],
      json["createnin"],
      json["hemoglobin"],
      json["weight"],
      json["inserted_date"],
      json["calcium"],
      json["range"],
    );
  }

  toJson () {
    return{
      "user_id" : user_id,
      "pressure" : pressure,
      "glucose" : glucose,
      "random_glucose" : random_glucose,
      "sodium" : sodium,
      "potassium" : potassium,
      "phosphate" : phosphate,
      "createnin" : createnin,
      "hemoglobin" : hemoglobin,
      "weight" : weight,
      "inserted_date" : inserted_date,
      "calcium" : calcium,
      "range" : range
    };
  }

  String getFormattedDate() {
    initializeDateFormatting();
    DateTime dateTime = DateFormat('MMMM d, y', 'en_US').parse("$inserted_date");
    var formatter = DateFormat.yMMMMd('ar_EG');
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }

}