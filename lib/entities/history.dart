import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class History{
  int? _hourTaken;
  int? _minuteTaken;
  String? _dateString;
  String? _pillName;
  int? _action;
  String? _doseQuantity;
  String? _doseQuantity2;
  int? _dayOfWeek;
  String? _doseUnit;
  String? _doseUnit2;
  int? _alarmId;

  History() {}


  History.name(
      this._hourTaken,
      this._minuteTaken,
      this._dateString,
      this._pillName,
      this._action,
      this._doseQuantity,
      this._doseQuantity2,
      this._dayOfWeek,
      this._doseUnit,
      this._doseUnit2,
      this._alarmId);

  int get hourTaken => _hourTaken!;

  set hourTaken(int value) {
    _hourTaken = value;
  }

  int get minuteTaken => _minuteTaken!;

  int get alarmId => _alarmId!;

  set alarmId(int value) {
    _alarmId = value;
  }

  String get doseUnit2 => _doseUnit2!;

  set doseUnit2(String value) {
    _doseUnit2 = value;
  }

  String get doseUnit => _doseUnit!;

  set doseUnit(String value) {
    _doseUnit = value;
  }

  int get dayOfWeek => _dayOfWeek!;

  set dayOfWeek(int value) {
    _dayOfWeek = value;
  }

  String get doseQuantity2 => _doseQuantity2!;

  set doseQuantity2(String value) {
    _doseQuantity2 = value;
  }

  String get doseQuantity => _doseQuantity!;

  set doseQuantity(String value) {
    _doseQuantity = value;
  }

  int get action => _action!;

  set action(int value) {
    _action = value;
  }

  String get pillName => _pillName!;

  set pillName(String value) {
    _pillName = value;
  }

  String get dateString => _dateString!;

  set dateString(String value) {
    _dateString = value;
  }

  set minuteTaken(int value) {
    _minuteTaken = value;
  }

  String getAm_pmTaken() {
    return (hourTaken < 12) ? "ص" : "م";
  }

  DateTime getdate()
  {
    initializeDateFormatting();
    DateTime dateTime = DateFormat('MMMM d, y', 'en_US').parse("$dateString");
    return dateTime;
  }

  String getStringTime() {
    int nonMilitaryHour = hourTaken % 12;
    if (nonMilitaryHour == 0) {
      nonMilitaryHour = 12;
    }
    if (minuteTaken < 10) {
      return "${nonMilitaryHour.toString()}:0${minuteTaken.toString()} ${getAm_pmTaken()}";
    } else {
      return "${nonMilitaryHour.toString()}:${minuteTaken.toString()} ${getAm_pmTaken()}";
    }
  }

  String getFormattedDose() {
    return "${doseQuantity} ${doseUnit} ${doseQuantity2} ${doseUnit2}";
  }

  String getFormattedDate() {
    initializeDateFormatting();
    DateTime dateTime = DateFormat('MMMM d, y', 'en_US').parse("$dateString");
    var formatter = DateFormat.yMMMMd('ar_EG');
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }

  factory History.fromJson(Map<String, dynamic> json) {
    return History.name(
        json['hour'],
        json['minute'],
        json['date'],
        json['pillName'],
        json['action'],
        json['dose_quantity'],
        json['dose_quantity2'],
        json['dayOfWeek'],
        json['dose_units'],
        json['dose_units'],
        json['alarm_id']
    );
  }

}