import 'package:android_autostart/android_autostart.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicine_time/LocalDB.dart';
import 'package:medicine_time/entities/history.dart';
import 'package:medicine_time/pages/LoginPage.dart';
import 'package:medicine_time/pages/add_medicine.dart';
import 'package:medicine_time/pages/choose_medicine.dart';
import 'package:medicine_time/pages/home_page.dart';
import 'package:medicine_time/pages/medicine_taken.dart';
import 'package:medicine_time/pages/static_view.dart';
import 'package:medicine_time/services/alarm_service.dart';
import 'package:medicine_time/services/history_service.dart';
import 'package:medicine_time/services/measures_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import 'entities/Measure.dart';
import 'entities/medicine_alarm.dart';
import 'globals.dart' as globals;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? status = await globals.user.read(key: "logged");


  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =  InitializationSettings(
    android: initializationSettingsAndroid,);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: Homepage().selectNotification);


  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  print(await Permission.ignoreBatteryOptimizations.request().isGranted);
  try {
    //check auto-start availability.
    var test = await isAutoStartAvailable;
    print(test);
    //if available then navigate to auto-start setting page.
    if (test!) await getAutoStartPermission();
  } on PlatformException catch (e) {
    print(e);
  }


  if(status=="true"&&notificationAppLaunchDetails!.didNotificationLaunchApp) {
    print(notificationAppLaunchDetails.payload);
    List<String> arguments = notificationAppLaunchDetails.payload!.split(" ");
    if(arguments[0]=="Alarm") {
      runApp(MaterialApp(navigatorKey: navigatorKey,
        home: MedicineTaken(int.parse(arguments[1])),));
    } else if(arguments[0]=="Static") {
      runApp(MaterialApp(navigatorKey: navigatorKey,
          home: StaticView(int.parse(arguments[1]))));
    } else {
      runApp(MaterialApp(navigatorKey: navigatorKey,
          home: Homepage()));
    }

  } else if (status=="true"&& !notificationAppLaunchDetails!.didNotificationLaunchApp) {
    runApp(MaterialApp(navigatorKey: navigatorKey,
        home: Homepage()));
  } else {
    runApp(MaterialApp(navigatorKey: navigatorKey,
        home : LoginPage()));
  }
}