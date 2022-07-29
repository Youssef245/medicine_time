class MedicineAlarm {

  int? _id;
  int? _hour;
  int? _weekday;
  int? _minute;
  String? _pillName;
  String? _doseQuantity;
  String? _doseUnit;
  String? _doseUnit2;
  String? _dateString;
  String? _doseQuantity2;
  int? _alarmId;
  int? _userID;

  MedicineAlarm() {
    _doseQuantity2="0";
  }


  MedicineAlarm.name(
      this._id,
      this._hour,
      this._weekday,
      this._minute,
      this._pillName,
      this._doseQuantity,
      this._doseUnit,
      this._doseUnit2,
      this._dateString,
      this._doseQuantity2,
      this._alarmId,);

  MedicineAlarm.name2(
      this._hour,
      this._weekday,
      this._minute,
      this._pillName,
      this._doseQuantity,
      this._doseUnit,
      this._doseUnit2,
      this._dateString,
      this._doseQuantity2,
      this._alarmId,
      this._userID);

  int get alarmId => _alarmId!;

  set alarmId(int value) {
    _alarmId = value;
  }

  String get doseQuantity2 => _doseQuantity2!;

  set doseQuantity2(String value) {
    _doseQuantity2 = value;
  }

  String get dateString => _dateString!;

  set dateString(String value) {
    _dateString = value;
  }

  String get doseUnit2 => _doseUnit2!;

  set doseUnit2(String value) {
    _doseUnit2 = value;
  }

  String get doseUnit => _doseUnit!;

  set doseUnit(String value) {
    _doseUnit = value;
  }

  String get doseQuantity => _doseQuantity!;

  set doseQuantity(String value) {
    _doseQuantity = value;
  }

  String get pillName => _pillName!;

  set pillName(String value) {
    _pillName = value;
  }

  int get minute => _minute!;

  set minute(int value) {
    _minute = value;
  }

  int get weekday => _weekday!;

  set weekday(int value) {
    _weekday = value;
  }

  int get hour => _hour!;

  set hour(int value) {
    _hour = value;
  }

  int get id => _id!;

  set id(int value) {
    _id = value;
  }


  int get userID => _userID!;

  set userID(int value) {
    _userID = value;
  }

  List<int> ids = [];
  List <bool> dayOfWeek=[];

  String getAm_pm() {
    return (hour < 12) ? "ص" : "م";
  }

  String getStringTime() {
    int nonMilitaryHour = hour % 12;
    if (nonMilitaryHour == 0) {
      nonMilitaryHour = 12;
    }
    if (minute < 10) {
      return "${nonMilitaryHour.toString()}:0${minute.toString()} ${getAm_pm()}";
    } else {
      return "${nonMilitaryHour.toString()}:${minute.toString()} ${getAm_pm()}";
    }
  }

   String getFormattedDose() {
    return "${doseQuantity} ${doseUnit} ${doseQuantity2} ${doseUnit2}";
  }


  toJson(){
    return {
    "hour": _hour,
    "day_of_week": _weekday,
    "minute": _minute,
    "pillName": _pillName,
    "dose_quantity": _doseQuantity,
    "dose_units": _doseUnit,
    "dose_units2": _doseUnit2,
    "date": _dateString,
    "dose_quantity2": _doseQuantity2,
    "alarm_id" : _alarmId,
    "user_id" : _userID
    };

  }

  factory MedicineAlarm.fromJson(Map<String, dynamic> json) {
    return MedicineAlarm.name(
      json['id'],
      json['hour'],
      json['weekday'],
      json['minute'],
      json['pillName'],
      json['dose_quantity'],
      json['dose_units'],
      json['dose_units2'],
      json['date'],
      json['dose_quantity2'],
      json['alarm_id'],
    );
  }
}