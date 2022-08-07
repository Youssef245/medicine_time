import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicine_time/LocalDB.dart';
import 'package:medicine_time/entities/history.dart';
import 'package:medicine_time/entities/medicine_alarm.dart';
import 'package:medicine_time/pages/ButtonsPage.dart';
import 'package:medicine_time/pages/LoginPage.dart';
import 'package:medicine_time/pages/ViewAlarms.dart';
import 'package:medicine_time/pages/about.dart';
import 'package:medicine_time/pages/add_measures.dart';
import 'package:medicine_time/pages/add_medicine.dart';
import 'package:medicine_time/globals.dart' as globals;
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

class Homepage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
        title: 'HomePage',  home:MyHomepage()
    );
  }

  void selectNotification(String? payload) async {
    print("fklewfewlfkwe");
    if (payload != null) {
      debugPrint('notification payload: $payload');
      navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) =>
          MedicineTaken(int.parse(payload)) ));
    }
  }

}


class MyHomepage extends StatefulWidget{
  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
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
    sendOffline();
    setState(() {
      isLoaded = true;
    });
  }
  
  sendOffline () async {

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =  InitializationSettings(
      android: initializationSettingsAndroid,);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: Homepage().selectNotification);

    LocalDB dbHelper = LocalDB();
    AlarmService alarmService = AlarmService();
    List<MedicineAlarm> offlineAlarms = await dbHelper.getOfflineAlarms();
    offlineAlarms.forEach((element) async {await alarmService.createAlarm(element.toJson());});

    HistoryService historyService = HistoryService();
    List<History> offlineHistory = await dbHelper.getOfflineHistories();
    offlineHistory.forEach((element) async { await historyService.createHistory(element.toJson());});

    MeasuresService measuresService = MeasuresService();
    List<Measure> offlineMeasures = await dbHelper.getOfflineMeasures();
    offlineMeasures.forEach((element) async {await measuresService.addMeasure(element.toJson());});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoaded ? SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30,),
              Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton(onPressed: () async {
                  await globals.user.write(key: 'logged', value: "false");
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