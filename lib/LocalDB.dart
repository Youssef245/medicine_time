import 'package:medicine_time/entities/history.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'entities/medicine_alarm.dart';

class LocalDB {

  LocalDB();

  var databasesPath;
  String? path;

  final String users_Table = "users";
  final String ALARM_TABLE = "alarms";
  final String HISTORIES_TABLE = "histories";

  final String KEY_id = "id";
  final String KEY_name = "name";
  final String KEY_ROWID = "id";
  final String KEY_PILLNAME = "pillName";
  final String KEY_INTENT = "intent";
  final String KEY_HOUR = "hour";
  final String KEY_MINUTE = "minute";
  final String KEY_DAY_WEEK = "day_of_week";
  final String KEY_ALARMS_PILL_NAME = "pillName";
  final String KEY_DOSE_QUANTITY = "dose_quantity";
  final String KEY_DOSE_QUANTITY2 = "dose_quantity2";
  final String KEY_DOSE_UNITS = "dose_units";
  final String KEY_ALARM_ID = "alarm_id";
  final String KEY_DOSE_UNITS2 = "dose_units2";
  final String Key_Notsent = "not_sent";
  final String KEY_PILLTABLE_ID = "pill_id";
  final String KEY_ALARMTABLE_ID = "alarm_id";
  final String KEY_DATE_STRING = "date";
  final String KEY_ACTION = "action";
  String? CREATE_users_TABLE;
  String? CREATE_ALARM_TABLE;
  String? CREATE_HISTORIES_TABLE;


  //////// INITIALIZATIONS ////////

  void createStatements (){
    CREATE_users_TABLE =
        "create table " + users_Table + "("
            + KEY_id + " integer  primary key not null,"
            + KEY_name + " text not null" + ")";

    CREATE_ALARM_TABLE =
        "create table " + ALARM_TABLE + "("
            + KEY_ROWID + " integer primary key,"
            + KEY_ALARM_ID + " integer,"
            + KEY_HOUR + " integer,"
            + KEY_MINUTE + " integer,"
            + KEY_ALARMS_PILL_NAME + " text not null,"
            + KEY_DATE_STRING + " text,"
            + KEY_DOSE_QUANTITY + " text,"
            + KEY_DOSE_UNITS + " text,"
            + KEY_DAY_WEEK + " integer,"
            + KEY_DOSE_QUANTITY2 + " text,"
            + KEY_DOSE_UNITS2 + " text"+ ")";

    CREATE_HISTORIES_TABLE =
        "CREATE TABLE $HISTORIES_TABLE ($KEY_ROWID integer primary key, $KEY_PILLNAME text not null, $KEY_DOSE_QUANTITY text,"
            "$KEY_DOSE_UNITS text, $KEY_DOSE_QUANTITY2 text,$KEY_DOSE_UNITS2 text ,$KEY_DATE_STRING text, $KEY_HOUR integer, $KEY_ACTION integer, $KEY_MINUTE integer , $KEY_ALARM_ID integer,"
            " $KEY_DAY_WEEK integer,$Key_Notsent integer)";

  }


  Future<Database> openDB () async {
    databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'medicine_time.db');
    Database database = await openDatabase(path!, version: 1,
        onCreate: (Database db, int version) async {
          createStatements();
          await db.execute(CREATE_users_TABLE!);
          await db.execute(CREATE_ALARM_TABLE!);
          await db.execute(CREATE_HISTORIES_TABLE!);
        });
    return database;

  }

  void closeDB (Database database) async {
    await database.close();

  }

  //////// POST ////////

  void createuser(int id,String name) async {
    Database database = await openDB();
    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO $users_Table($KEY_name, $KEY_id) VALUES($name , $id)');
      print('inserted1: $id1');
    });

    closeDB(database);
  }

  Future<int> createAlarm (MedicineAlarm alarm) async {
    int id=0;
    Database database = await openDB();
    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          "INSERT INTO $ALARM_TABLE($KEY_HOUR, $KEY_MINUTE, $KEY_DAY_WEEK, $KEY_ALARMS_PILL_NAME,"
              "$KEY_DOSE_QUANTITY, $KEY_DOSE_UNITS,$KEY_DOSE_QUANTITY2, $KEY_DOSE_UNITS2,$KEY_DATE_STRING, $KEY_ALARM_ID)"
              "VALUES(${alarm.hour}, ${alarm.minute}, ${alarm.weekday}, '${alarm.pillName}', ${alarm.doseQuantity}, "
              "'${alarm.doseUnit}', ${alarm.doseQuantity2}, '${alarm.doseUnit2}', '${alarm.dateString}', ${alarm.alarmId})");
      print('inserted1: $id1');
      id=id1;
    });
    closeDB(database);
    return id;

  }

  Future<int> createHistory (History history) async{
    int id=0;
    Database database = await openDB();
    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          "INSERT INTO $HISTORIES_TABLE($KEY_PILLNAME  , $KEY_DOSE_QUANTITY , $KEY_DOSE_UNITS , $KEY_DOSE_QUANTITY2 ,"
              "$KEY_DOSE_UNITS2  ,$KEY_DATE_STRING , $KEY_HOUR , $KEY_ACTION , $KEY_MINUTE  , $KEY_ALARM_ID ,"
              " $KEY_DAY_WEEK) "
              "VALUES('${history.pillName}', ${history.doseQuantity}, '${history.doseUnit}',${history.doseQuantity2},"
              " '${history.doseUnit2}','${history.dateString}',${history.hourTaken}, ${history.action}, "
              "${history.minuteTaken},${history.alarmId}, ${history.dayOfWeek})");
      print('inserted1: $id1');
      id=id1;
    });
    closeDB(database);
    return id;
  }

  //////// GET ////////

  void getUser(){}

  Future<List<MedicineAlarm>> getAlarmsbyDay (DateTime dateTime) async {
    Database database = await openDB();
    List <MedicineAlarm> alarms = [];
    List<Map> list = await database.rawQuery('SELECT * FROM alarms where $KEY_DAY_WEEK = ${dateTime.weekday}');
    alarms = list.map((alarm) => MedicineAlarm.fromJson(alarm as Map<String, dynamic>)).toList();
    print(list.length);
    closeDB(database);
    return alarms;
  }

  Future<List<MedicineAlarm>> getallAlarms () async {
    Database database = await openDB();
    List <MedicineAlarm> alarms = [];
    List<Map> list = await database.rawQuery('SELECT * FROM alarms');
    alarms = list.map((alarm) => MedicineAlarm.fromJson(alarm as Map<String, dynamic>)).toList();
    closeDB(database);
    return alarms;
  }

  Future<List<MedicineAlarm>> getAlarmsbyPill (String pillName) async {
    Database database = await openDB();
    List <MedicineAlarm> alarms = [];
    List<Map> list = await database.rawQuery("SELECT * FROM alarms where $KEY_ALARMS_PILL_NAME = N'$pillName'");
    alarms = list.map((alarm) => MedicineAlarm.fromJson(alarm as Map<String, dynamic>)).toList();
    closeDB(database);
    return alarms;
  }

  Future<List<MedicineAlarm>> getAlarmsbyID (int id) async {
    Database database = await openDB();
    List <MedicineAlarm> alarms = [];
    List<Map> list = await database.rawQuery("SELECT * FROM alarms where $KEY_ROWID = $id");
    alarms = list.map((alarm) => MedicineAlarm.fromJson(alarm as Map<String, dynamic>)).toList();
    closeDB(database);
    return alarms;
  }

  Future<List<History>> getHistories () async {
    Database database = await openDB();
    List <History> alarms = [];
    List<Map> list = await database.rawQuery("SELECT * FROM $HISTORIES_TABLE order by date(date) desc,hour asc,minute asc");
    alarms = list.map((alarm) => History.fromJson(alarm as Map<String, dynamic>)).toList();
    closeDB(database);
    return alarms;
  }

  //////// DELETE ////////

  void deleteUser () {}

  Future deleteAlarm (MedicineAlarm medicineAlarm) async{
    Database database = await openDB();
    await database.rawDelete('DELETE FROM $ALARM_TABLE WHERE $KEY_ALARM_ID = ?', [medicineAlarm.alarmId]);
    closeDB(database);
  }
  Future deleteHistory() async{
    Database database = await openDB();
    await database.rawDelete('DELETE FROM $HISTORIES_TABLE');
    closeDB(database);
  }












}