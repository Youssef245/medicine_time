import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:medicine_time/LocalDB.dart';
import 'package:medicine_time/entities/history.dart';
import 'package:medicine_time/entities/medicine_alarm.dart';
import 'package:medicine_time/pages/ButtonsPage.dart';
import 'package:medicine_time/pages/LoginPage.dart';
import 'package:medicine_time/pages/ViewAlarms.dart';
import 'package:medicine_time/pages/about.dart';
import 'package:medicine_time/pages/add_measures.dart';
import 'package:medicine_time/api.dart';
import 'package:medicine_time/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:medicine_time/pages/static_view.dart';
import 'package:medicine_time/pages/survey.dart';
import 'package:medicine_time/pages/update_information.dart';
import 'package:medicine_time/services/alarm_service.dart';
import 'package:medicine_time/services/history_service.dart';
import 'package:medicine_time/services/measures_service.dart';

import '../entities/Measure.dart';
import 'add_side_effect.dart';
import 'ask_doctor.dart';
import 'medicine_taken.dart';

final navigatorKey = GlobalKey<NavigatorState>();


class Homepage extends StatefulWidget{
  @override
  State<Homepage> createState() => _MyHomepageState();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  LocalDB db = LocalDB();

  void selectNotification(NotificationResponse? notificationResponse) async {
    String? payload = notificationResponse!.payload;
    print("fklewfewlfkwe");
    if (payload != null) {
      debugPrint('notification payload: $payload');
      List<String> arguments = payload.split(" ");
      if(arguments[0]=="Alarm") {
        bool recorded = await db.historyRecoreded(int.parse(arguments[1]), globals.getDateNow());
        if(!recorded) {
        navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) =>
            MedicineTaken(int.parse(arguments[1])) ));
        }
      } else if(arguments[0]=="Static") {
        Random random = Random();
        int randomNumber = random.nextInt(42)+1;
        navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) =>
            StaticView(randomNumber) ));
      } else {
        Random random = Random();
        int randomNumber = random.nextInt(6);
        switch (randomNumber) {
          case 0 :
            navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) =>
                AddMeasures()));
            break;
          case 1 :
            navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) =>
                AddSideEffects() ));
            break;
          case 2 :
            navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) =>
                Survey() ));
            break;
          case 3 :
            navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) =>
                ButtonsPage("معلومات ونصائح") ));
            break;
          case 4 :
            navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) =>
                AskDoctor() ));
            break;
          case 5 :
            navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) =>
                ButtonsPage("الاختبارات القصيرة") ));
            break;
        }
      }
    }
  }
  sendOffline () async {
    print("here!!");

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =  InitializationSettings(
      android: initializationSettingsAndroid,);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: Homepage().selectNotification);

    String? id = await globals.user.read(key: "id");

    final response =
    await http.head(Uri.parse(medicinesURL));

    print(response.statusCode);

    if (response.statusCode == 200) {

      print("object");

      LocalDB dbHelper = LocalDB();
      AlarmService alarmService = AlarmService();
      List<MedicineAlarm> offlineAlarms = await dbHelper.getOfflineAlarms();
      offlineAlarms.forEach((element) async {
        element.userID = int.parse(id!);
        await alarmService.createAlarm(element);
      });
      await dbHelper.deleteOfflineAlarms();

      HistoryService historyService = HistoryService();
      List<History> offlineHistory = await dbHelper.getOfflineHistories();
      offlineHistory.forEach((element) async {
        var formatter = DateFormat.yMMMMd('en_US');
        DateTime dateTime = formatter.parse(element.dateString);
        //DateTime dateTime = DateTime.parse(element.dateString);
        element.userID = int.parse(id!);
        element.dayOfWeek = dateTime.weekday;
        await historyService.createHistory(element);
      });
      await dbHelper.deleteOfflineHistory();

      MeasuresService measuresService = MeasuresService();
      List<Measure> offlineMeasures = await dbHelper.getOfflineMeasures();
      offlineMeasures.forEach((element) async {
        element.user_id = int.parse(id!);
        await measuresService.addMeasure(element.toJson());
      });
      await dbHelper.deleteOfflineMeasures();
    }
  }
}

class _MyHomepageState extends State<Homepage> {
  bool isLoaded = false;
  List<_HomePageItem> items = [_HomePageItem("الأدوية", "images/medicines.png",1),
    _HomePageItem("حسابي", "images/users.png",2),
    _HomePageItem("الأعراض و الآثار الجانبية", "images/symptoms1.png",3),
    _HomePageItem("القياسات", "images/measures.png",4),
    _HomePageItem("اسأل الطبيب او الصيدلي", "images/call.png",5),
    _HomePageItem("معلومات ونصائح", "images/knowledge.png",6),
    _HomePageItem("عن التطبيق", "images/about.png",7),
    _HomePageItem("استبيان سهولة الاستخدام", "images/survey.png",8),
  ];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    widget.sendOffline();
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: isLoaded ? SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30,),
                Align(
                  alignment: Alignment.topLeft,
                  child: ElevatedButton(onPressed: () async {
                    await globals.user.write(key: 'logged', value: "false");
                    await flutterLocalNotificationsPlugin.cancel(900);
                    await flutterLocalNotificationsPlugin.cancel(901);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        LoginPage()), (Route<dynamic> route) => false);
                  }, child: Text("خروج",style: const TextStyle(color: Colors.teal),),
                    style: ElevatedButton.styleFrom(primary: Colors.white70),),
                ),
                Image.asset("images/home.png",
                width: 200,
                height: 200,),
                for(int i=0;i<items.length;i=i+2)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(child: cardWidget(items[i+1],context)),
                      Flexible(child: cardWidget(items[i],context)),
                    ],
                  )
              ],
            ),
          ) : const Center(child: CircularProgressIndicator() ,),
        ),
    );
  }

  Widget cardWidget (_HomePageItem item,BuildContext context)
  {
    return Container(
      child: GestureDetector(
        child: Card(
          color: Colors.white,
          elevation: 3,
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Flexible( child: Image.asset(item.assetName,
                width: 100,
                height: 100,),),
              const SizedBox(height: 10,),
              Flexible( child: Text(item.value, style: const TextStyle(
                  fontWeight: FontWeight.bold ),),
              )
            ],
          ),
        ),
        onTap: () => onClicked(context,item.choice),
      ),
      width: 150,
      height: 150,
    );
  }
}

class _HomePageItem {
  String value;
  String assetName;
  int choice;
  _HomePageItem(this.value,this.assetName,this.choice);
}

void onClicked (BuildContext context,int index){
  switch (index) {
    case 1:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ViewAlarms(),
      ));
      break;
    case 2:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UpdateInformation(),
      ));
      break;
    case 3:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddSideEffects(),
      ));
      break;
    case 4:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddMeasures(),
      ));
      break;
    case 5:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AskDoctor(),
      ));
      break;
    case 6:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ButtonsPage("معلومات ونصائح"),
      ));
      break;
    case 7:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => About(),
      ));
      break;
    case 8:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Survey(),
      ));
      break;
  }
}