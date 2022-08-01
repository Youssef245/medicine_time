import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:medicine_time/LocalDB.dart';
import 'package:medicine_time/entities/history.dart';
import 'package:medicine_time/pages/LoginPage.dart';
import 'package:medicine_time/pages/add_medicine.dart';
import 'package:medicine_time/pages/choose_medicine.dart';
import 'package:medicine_time/pages/home_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import 'globals.dart' as globals;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*History history = History.name(5, 30, "July 28, 2022", "أتاكند", 1, "0", "0", 3, "مجم", "قرص", 517);
  History history2 = History.name(5, 30, "August 5, 2022", "أتاكند", 0, "0", "0", 3, "مجم", "قرص", 517);
  History history4 = History.name(2, 30, "August 5, 2022", "أتاكند", 0, "0", "0", 3, "مجم", "قرص", 517);
  History history5 = History.name(2, 25, "August 5, 2022", "أتاكند", 0, "0", "0", 3, "مجم", "قرص", 517);
  History history3 = History.name(5, 30, "July 10, 2022", "أتاكند", 1, "0", "0", 3, "مجم", "قرص", 517);*/
  LocalDB dbHelper = LocalDB();
  await dbHelper.deleteHistory();
  /*await dbHelper.createHistory(history);
  await dbHelper.createHistory(history2);
  await dbHelper.createHistory(history3);
  await dbHelper.createHistory(history4);
  await dbHelper.createHistory(history5);*/
  //print(await Permission.ignoreBatteryOptimizations.request().isGranted);
  String? status = await globals.user.read(key: "logged");
  if(status=="true")
    runApp(Homepage());
  else
    runApp(LoginPage());
}