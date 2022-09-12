import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicine_time/LocalDB.dart';
import 'package:medicine_time/entities/history.dart';
import 'package:medicine_time/entities/medicine_alarm.dart';
import 'package:medicine_time/pages/ButtonsPage.dart';
import 'package:medicine_time/pages/LoginPage.dart';
import 'package:medicine_time/pages/add_measures.dart';
import 'package:medicine_time/pages/add_side_effect.dart';
import 'package:medicine_time/pages/ask_doctor.dart';
import 'package:medicine_time/pages/home_page.dart';
import 'package:medicine_time/pages/medicine_taken.dart';
import 'package:medicine_time/pages/static_view.dart';
import 'package:medicine_time/pages/survey.dart';
import 'package:permission_handler/permission_handler.dart';
import 'globals.dart' as globals;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? status = await globals.user.read(key: "logged");

  History history1 = History.name(2, 24, 'September 1, 2022', 'ابريكس', 1,
      '0', '0', 5, 'مجم', 'مل', 945);
  History history2 = History.name(2, 26, 'September 1, 2022', 'ابريكس', 1,
      '0', '0', 5, 'مجم', 'مل', 945);
  History history3 = History.name(2, 24, 'September 10, 2022', 'ابريكس', 1,
      '0', '0', 5, 'مجم', 'مل', 945);
  History history4 = History.name(2, 24, 'September 12, 2022', 'ابريكس', 1,
      '0', '0', 5, 'مجم', 'مل', 945);

  LocalDB db = LocalDB();
  await db.createHistory(history1);
  await db.createHistory(history2);
  await db.createHistory(history3);
  await db.createHistory(history4);

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =  InitializationSettings(
    android: initializationSettingsAndroid,);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: Homepage().selectNotification);


  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  await Permission.ignoreBatteryOptimizations.request().isGranted;


  if(status=="true"&&notificationAppLaunchDetails!.didNotificationLaunchApp) {
    print(notificationAppLaunchDetails.payload);
    List<String> arguments = notificationAppLaunchDetails.payload!.split(" ");
    if(arguments[0]=="Alarm") {
      runApp(MaterialApp(navigatorKey: navigatorKey,
        home: MedicineTaken(int.parse(arguments[1])),));
    } else if(arguments[0]=="Static") {
      Random random = Random();
      int randomNumber = random.nextInt(42)+1;
      runApp(MaterialApp(navigatorKey: navigatorKey,
          home: StaticView(randomNumber)));
    } else {
      Random random = Random();
      int randomNumber = random.nextInt(6);
      switch (randomNumber) {
        case 0 :
          runApp(MaterialApp(navigatorKey: navigatorKey,
              home: AddMeasures() ));
          break;
        case 1 :
          runApp(MaterialApp(navigatorKey: navigatorKey,
              home: AddSideEffects() ));
          break;
        case 2 :
          runApp(MaterialApp(navigatorKey: navigatorKey,
              home: Survey() ));
          break;
        case 3 :
          runApp(MaterialApp(navigatorKey: navigatorKey,
              home:  ButtonsPage("معلومات ونصائح") ));
          break;
        case 4 :
          runApp(MaterialApp(navigatorKey: navigatorKey,
              home: AskDoctor() ));
          break;
        case 5 :
          runApp(MaterialApp(navigatorKey: navigatorKey,
              home: ButtonsPage("الاختبارات القصيرة") ));
          break;
      }
    }

  } else if (status=="true"&& !notificationAppLaunchDetails!.didNotificationLaunchApp) {
    runApp(MaterialApp(navigatorKey: navigatorKey,
        home: Homepage()));
  } else {
    runApp(MaterialApp(navigatorKey: navigatorKey,
        home : LoginPage()));
  }
}