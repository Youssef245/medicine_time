import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicine_time/entities/history.dart';
import 'package:medicine_time/pages/add_medicine.dart';
import 'package:medicine_time/services/medicine_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../LocalDB.dart';
import '../entities/medicine_alarm.dart';
import '../services/alarm_service.dart';
import '../services/history_service.dart';
import 'home_page.dart';

class MedicineTaken extends StatelessWidget {
  int alarmId;
  MedicineTaken(this.alarmId);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'MedicineTaken', home: MyMedicineTaken(alarmId));
  }
}

class MyMedicineTaken extends StatefulWidget {
  int alarmId;
  MyMedicineTaken(this.alarmId);

  @override
  State<MyMedicineTaken> createState() => _MyMedicineTakenState();
}

class _MyMedicineTakenState extends State<MyMedicineTaken> {
  MedicineAlarm? alarm;
  LocalDB dbHelper = LocalDB();
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    getAlarm();
  }

  getAlarm () async {
    alarm = await dbHelper.getAlarmsbyID(widget.alarmId);
    setState(() {
      isLoaded = true;
    });
  }

  /*resetNotification() async
  {
    DateTime dateTime = DateTime.now().add(const Duration(days: 7));

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =  InitializationSettings(
      android: initializationSettingsAndroid,);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        alarm!.id,
        'حان وقت الدواء',
        'اضغط هنا!',
        tz.TZDateTime.from(dateTime, tz.getLocation('Africa/Cairo')),
        NotificationDetails(
            android: AndroidNotificationDetails(
              'ALARMS_${alarm!.id}', 'Alarm_${alarm!.id}',
              channelDescription: 'Alarm Channel for ${alarm!.id}',importance: Importance.high, priority: Priority.high,
              playSound: true,
              sound: RawResourceAndroidNotificationSound('cuco_sound'),
            )),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        payload: alarm!.alarmId.toString());
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  }

  void selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MedicineTaken(int.parse(payload)),
      ));
    }
  }*/

  createHistory(bool taken) async
  {
    int action = taken ? 1 : 0 ;
    History history = History.name(alarm!.hour, alarm!.minute, alarm!.dateString, alarm!.pillName,
        action, alarm!.doseQuantity, alarm!.doseQuantity2, alarm!.weekday, alarm!.doseUnit, alarm!.doseUnit2, alarm!.alarmId);
    await dbHelper.createHistory(history);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile||connectivityResult == ConnectivityResult.wifi) {
      HistoryService service = HistoryService();
      service.createHistory(history.toJson());
    } else{
       dbHelper.createOfflineHistory(history);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoaded ? Column(
          children: [
            Container(
              color: Colors.teal,
              height: 180 ,
              width: MediaQuery.of(context).size.width,
              child: const Center(child: Text("هل أخذت الدواء؟",
              style: TextStyle(color:Colors.white,fontSize: 30),),)),
            Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 175,
                    child: Card(
                      elevation: 4,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20 ),
                            child: Text(
                              alarm!.getStringTime(),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 35),
                            ),
                          ),
                          const Divider(color: Colors.teal),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 10,),
                                  Image.asset(
                                    'images/capsules.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  const SizedBox(width: 10,),
                                  Column(
                                    children: [
                                      Text(
                                        alarm!.pillName,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        alarm!.getFormattedDose(),
                                        style: const TextStyle(
                                            color: Colors.black45,
                                            fontSize: 15),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  TextButton(onPressed: () async{
                                    //resetNotification();
                                    await createHistory(false);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MyHomepage(),
                                    ));
                                  }, child:
                                  Image.asset('images/image_reminder_configure.png',height: 40 , width: 40,)),
                                  TextButton(onPressed: () async{
                                    await createHistory(true);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MyHomepage(),
                                    ));
                                  }, child:
                                  Image.asset('images/image_reminder_take.png',height: 40 , width: 40,))
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),

          ],
        ) : const Center(child: CircularProgressIndicator(),)
      );
  }
}
