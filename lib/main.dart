import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicine_time/LocalDB.dart';
import 'package:medicine_time/entities/history.dart';
import 'package:medicine_time/pages/LoginPage.dart';
import 'package:medicine_time/pages/add_medicine.dart';
import 'package:medicine_time/pages/choose_medicine.dart';
import 'package:medicine_time/pages/home_page.dart';
import 'package:medicine_time/pages/medicine_taken.dart';
import 'package:medicine_time/pages/static_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import 'globals.dart' as globals;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalDB dbHelper = LocalDB();
  await dbHelper.deleteHistory();
  String? status = await globals.user.read(key: "logged");


  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =  InitializationSettings(
    android: initializationSettingsAndroid,);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: Homepage().selectNotification);


  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();


  if(status=="true"&&notificationAppLaunchDetails!.didNotificationLaunchApp) {
    print(notificationAppLaunchDetails.payload);
    List<String> arguments = notificationAppLaunchDetails.payload!.split(" ");
    if(arguments[0]=="Alarm") {
      runApp(MaterialApp(home: MedicineTaken(int.parse(arguments[1])),));
    } else if(arguments[0]=="Static") {
      runApp(MaterialApp(home: StaticView(int.parse(arguments[1]))));
    } else {
      runApp(MaterialApp(home: Homepage()));
    }

  } else if (status=="true"&& !notificationAppLaunchDetails!.didNotificationLaunchApp) {
    runApp(MaterialApp(home: Homepage()));
  } else {
    runApp(MaterialApp(home : LoginPage()));
  }
}