import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
      runApp(MaterialApp(navigatorKey: navigatorKey,
          home: StaticView(int.parse(arguments[1]))));
    } else {
      switch (int.parse(arguments[1])) {
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