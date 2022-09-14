import 'package:medicine_time/entities/history.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'entities/Measure.dart';
import 'entities/medicine_alarm.dart';

class LocalDB {

  LocalDB();

  var databasesPath;
  String? path;

  final String users_Table = "users";
  final String ALARM_TABLE = "alarms";
  final String HISTORIES_TABLE = "histories";
  final String MEASURES_TABLE = "measures";

  final String KEY_id = "id";
  final String KEY_name = "name";
  final String KEY_ROWID = "id";
  final String KEY_PILLNAME = "pillName";
  final String KEY_INTENT = "intent";
  final String KEY_HOUR = "hour";
  final String KEY_MINUTE = "minute";
  final String KEY_DAY_WEEK = "day_of_week";
  final String KEY_EVERY_OTHER_DAY = "every_other_Day";
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
  String? CREATE_MEASURES_TABLE;
  String? CREATE_HISTORIES_TABLE;


  //////// INITIALIZATIONS ////////

  void createStatements (){
    CREATE_users_TABLE =
        "create table " + users_Table + "("
            + KEY_id + " integer  primary key not null,"
            + KEY_name + " text not null" + ")";

    CREATE_MEASURES_TABLE =
        "create table " + MEASURES_TABLE + "("
            + KEY_ROWID + " integer primary key,"
            + "pressure" + " text,"
            + "glucose" + " float,"
            + "random_glucose" + " float,"
            + "sodium" + " float,"
            + "potassium" + " float,"
            + "phosphate" + " float,"
            + "createnin" + " float,"
            + "hemoglobin" + " float,"
            + "weight" + " float,"
            + "inserted_date" + " text,"
            + "calcium" + " float,"
            + "range" + " float" + ")";

    CREATE_ALARM_TABLE =
        "create table " + ALARM_TABLE + "("
            + KEY_ROWID + " integer primary key,"
            + KEY_ALARM_ID + " integer,"
            + KEY_HOUR + " integer,"
            + KEY_MINUTE + " integer,"
            + KEY_EVERY_OTHER_DAY + " integer,"
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
          await db.execute(CREATE_MEASURES_TABLE!);
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
          "INSERT INTO $ALARM_TABLE($KEY_HOUR, $KEY_MINUTE, $KEY_DAY_WEEK, $KEY_EVERY_OTHER_DAY, $KEY_ALARMS_PILL_NAME,"
              "$KEY_DOSE_QUANTITY, $KEY_DOSE_UNITS,$KEY_DOSE_QUANTITY2, $KEY_DOSE_UNITS2,$KEY_DATE_STRING, $KEY_ALARM_ID)"
              "VALUES(${alarm.hour}, ${alarm.minute}, ${alarm.weekday},${alarm.everyOtherDay}, '${alarm.pillName}', ${alarm.doseQuantity}, "
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

  Future<int> addMeasure (Measure measure) async{
    int id=0;
    Database database = await openDB();
    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          "INSERT INTO $MEASURES_TABLE(pressure,glucose,random_glucose,sodium,potassium,phosphate,"
              "createnin,hemoglobin,weight,inserted_date,calcium,range)"
              "VALUES('${measure.pressure}', ${measure.glucose}, ${measure.random_glucose},${measure.sodium},"
              " ${measure.potassium},${measure.phosphate},${measure.createnin}, ${measure.hemoglobin}, "
              "${measure.weight},'${measure.inserted_date}', ${measure.calcium},${measure.range})");
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
    List<Map> list = await database.rawQuery('SELECT * FROM alarms where $KEY_DAY_WEEK = ${dateTime.weekday}  ORDER BY hour asc, minute asc');
    alarms = list.map((alarm) => MedicineAlarm.fromJson(alarm as Map<String, dynamic>)).toList();
    print(list.length);
    closeDB(database);
    return alarms;
  }

  Future<List<MedicineAlarm>> getallAlarms () async {
    Database database = await openDB();
    List <MedicineAlarm> alarms = [];
    List<Map> list = await database.rawQuery('SELECT * FROM alarms ORDER BY hour asc, minute asc');
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

  Future<MedicineAlarm> getAlarmsbyID (int id) async {
    Database database = await openDB();
    DateTime now = DateTime.now();
    MedicineAlarm alarm;
    List<Map> list = await database.rawQuery("SELECT * FROM alarms where $KEY_ALARM_ID = $id and $KEY_DAY_WEEK = ${now.weekday} ");
    alarm = MedicineAlarm.fromJson(list[0] as Map<String, dynamic>);
    closeDB(database);
    return alarm;
  }

  Future<List<MedicineAlarm>> getAlarmsbyAlarmID (int id) async {
    Database database = await openDB();
    List <MedicineAlarm> alarms = [];
    List<Map> list = await database.rawQuery("SELECT * FROM alarms where $KEY_ALARM_ID = $id");
    alarms = list.map((alarm) => MedicineAlarm.fromJson(alarm as Map<String, dynamic>)).toList();
    closeDB(database);
    return alarms;
  }

  Future<List<History>> getHistories () async {
    Database database = await openDB();
    List <History> alarms = [];
    List<Map> list = await database.rawQuery("SELECT * FROM $HISTORIES_TABLE ORDER BY date($KEY_DATE_STRING) desc");
    alarms = list.map((alarm) => History.fromJson(alarm as Map<String, dynamic>)).toList();
    closeDB(database);
    return alarms;
  }

  Future<bool> historyRecoreded (int alarm_id,String date) async {
    bool result;
    Database database = await openDB();
    List<Map> list =
    await database.rawQuery("select "
        +"histories.pillName , histories.date , histories.alarm_id "
        +"from "
        +"histories "
        +"where "
        +"histories.alarm_id = $alarm_id "
        +"and histories.date = '$date' ");
    if(list.isEmpty) {
      result = false;
    } else {
      result = true;
    }
    closeDB(database);
    return result;
  }

  Future<List<Measure>> getMeasures () async {
    Database database = await openDB();
    List <Measure> measures = [];
    List<Map> list = await database.rawQuery("SELECT * FROM $MEASURES_TABLE");
    measures = list.map((measure) => Measure.fromJson(measure as Map<String, dynamic>)).toList();
    closeDB(database);
    return measures;
  }

  //////// DELETE ////////

  void deleteUser () {}

  Future deleteAlarm (MedicineAlarm medicineAlarm) async{
    Database database = await openDB();
    int newID = 0;
    await database.rawQuery("UPDATE $HISTORIES_TABLE "
        "SET $KEY_ALARM_ID = $newID "
        "WHERE $KEY_ALARM_ID = ${medicineAlarm.alarmId}");

    await database.rawDelete('DELETE FROM $ALARM_TABLE WHERE $KEY_ALARM_ID = ?', [medicineAlarm.alarmId]);
    closeDB(database);
  }

  Future deleteHistory() async{
    Database database = await openDB();
    await database.rawDelete('DELETE FROM $HISTORIES_TABLE');
    closeDB(database);
  }

  //////// OFFLINE DATABASE ////////

  Future<Database> offlineDB () async {
    databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'medicine_time_offline.db');
    Database database = await openDatabase(path!, version: 1,
        onCreate: (Database db, int version) async {
          createStatements();
          await db.execute(CREATE_ALARM_TABLE!);
          await db.execute(CREATE_HISTORIES_TABLE!);
          await db.execute(CREATE_MEASURES_TABLE!);
        });
    return database;

  }

  void closeOffline (Database database) async {
    await database.close();

  }

  Future<int> createOfflineAlarm (MedicineAlarm alarm) async {
    int id=0;
    Database database = await offlineDB();
    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          "INSERT INTO $ALARM_TABLE($KEY_HOUR, $KEY_MINUTE, $KEY_DAY_WEEK, $KEY_ALARMS_PILL_NAME,"
              "$KEY_DOSE_QUANTITY, $KEY_DOSE_UNITS,$KEY_DOSE_QUANTITY2, $KEY_DOSE_UNITS2,$KEY_DATE_STRING, $KEY_ALARM_ID)"
              "VALUES(${alarm.hour}, ${alarm.minute}, ${alarm.weekday}, '${alarm.pillName}', ${alarm.doseQuantity}, "
              "'${alarm.doseUnit}', ${alarm.doseQuantity2}, '${alarm.doseUnit2}', '${alarm.dateString}', ${alarm.alarmId})");
      print('inserted1: $id1');
      id=id1;
    });
    closeOffline(database);
    return id;

  }

  Future<int> createOfflineHistory (History history) async{
    int id=0;
    Database database = await offlineDB();
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
    closeOffline(database);
    return id;
  }

  Future<int> addOfflineMeasure (Measure measure) async{
    int id=0;
    Database database = await offlineDB();
    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          "INSERT INTO $MEASURES_TABLE(pressure,glucose,random_glucose,sodium,potassium,phosphate,"
              "createnin,hemoglobin,weight,inserted_date,calcium,range)"
              "VALUES('${measure.pressure}', ${measure.glucose}, ${measure.random_glucose},${measure.sodium},"
              " ${measure.potassium},${measure.phosphate},${measure.createnin}, ${measure.hemoglobin}, "
              "${measure.weight},'${measure.inserted_date}', ${measure.calcium},${measure.range})");
      print('inserted1: $id1');
      id=id1;
    });
    closeOffline(database);
    return id;
  }

  Future<List<MedicineAlarm>> getOfflineAlarms () async {
    Database database = await offlineDB();
    List <MedicineAlarm> alarms = [];
    List<Map> list = await database.rawQuery('SELECT * FROM alarms');
    alarms = list.map((alarm) => MedicineAlarm.fromJson(alarm as Map<String, dynamic>)).toList();
    closeOffline(database);
    return alarms;
  }

  Future<List<History>> getOfflineHistories () async {
    Database database = await offlineDB();
    List <History> alarms = [];
    List<Map> list = await database.rawQuery("SELECT * FROM $HISTORIES_TABLE order by date(date) desc,hour asc,minute asc");
    alarms = list.map((alarm) => History.fromJson(alarm as Map<String, dynamic>)).toList();
    closeOffline(database);
    return alarms;
  }

  Future<List<Measure>> getOfflineMeasures () async {
    Database database = await offlineDB();
    List <Measure> measures = [];
    List<Map> list = await database.rawQuery("SELECT * FROM $MEASURES_TABLE");
    measures = list.map((measure) => Measure.fromJson(measure as Map<String, dynamic>)).toList();
    closeOffline(database);
    return measures;
  }

  Future deleteOfflineHistory() async{
    Database database = await offlineDB();
    await database.rawDelete('DELETE FROM $HISTORIES_TABLE');
    closeOffline(database);
  }

  Future deleteOfflineAlarms () async{
    Database database = await offlineDB();
    await database.rawDelete('DELETE FROM $ALARM_TABLE');
    closeOffline(database);
  }
  Future deleteOfflineMeasures () async{
    Database database = await offlineDB();
    await database.rawDelete('DELETE FROM $MEASURES_TABLE');
    closeOffline(database);
  }












}