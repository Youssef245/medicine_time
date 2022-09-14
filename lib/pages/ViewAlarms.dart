import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicine_time/pages/ViewHistory.dart';
import 'package:medicine_time/pages/add_medicine.dart';
import 'package:medicine_time/services/medicine_service.dart';

import '../LocalDB.dart';
import '../entities/medicine_alarm.dart';
import '../services/alarm_service.dart';
import 'home_page.dart';
import 'medicine_taken.dart';

class ViewAlarms extends StatefulWidget {
  ViewAlarms();

  @override
  State<ViewAlarms> createState() => _MyViewAlarmsState();
}

class _MyViewAlarmsState extends State<ViewAlarms> {
  bool isLoaded = false;
  LocalDB dbHelper = LocalDB();
  List<MedicineAlarm> alarms = [];
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    Homepage().sendOffline();
    getData();
  }

  getData() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =  InitializationSettings(
      android: initializationSettingsAndroid,);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: Homepage().selectNotification);

    alarms = await dbHelper.getAlarmsbyDay(date);
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child:  Text("الأدوية الحالية",style: TextStyle(color: Colors.white),)),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
              onPressed: ()  {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => ViewHistory()));
              },
              icon: const Icon(
                Icons.history,
                color: Colors.white,
              ))
        ],
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: IconButton(
              onPressed: () async {
                DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(DateTime.now().year + 1,
                      DateTime.now().month, DateTime.now().day),
                );
                if (newDate == null) return;
                setState(() {
                  date = newDate;
                  getData();
                });
              },
              icon: const Icon(
                Icons.date_range,
                color: Colors.white,
              ))
        ),
      ),
      body: SingleChildScrollView(
        child: isLoaded
            ? Column(
                children: [
                  ...alarms.map((alarm) {
                    return Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 10,
                          height: 175,
                          padding: EdgeInsets.only(left: 10),
                          child: Card(
                            elevation: 3,
                            color: Colors.white,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        alarm.getStringTime(),
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 35),
                                      ),
                                      IconButton(
                                          onPressed: () => showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text('هل انت متأكد من حذف الدواء ؟'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                                  child: const Text('إلغاء'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    AlarmService service =
                                                    AlarmService();
                                                    LocalDB localdb = LocalDB();
                                                    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
                                                    List<MedicineAlarm> deletedAlarms =  await localdb.getAlarmsbyAlarmID(alarm.alarmId);
                                                    deletedAlarms.forEach((element) async {await flutterLocalNotificationsPlugin.cancel(element.id);});
                                                    await localdb.deleteAlarm(alarm);
                                                    await service.deleteAlarm(alarm);
                                                    getData();
                                                    Navigator.pop(context, 'OK');
                                                  },
                                                  child: const Text('تأكيد'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          icon: const Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                            size: 35,
                                          ))
                                    ],
                                  ),
                                ),
                                const Divider(color: Colors.teal),
                                const SizedBox(height: 10,),
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
                                          alarm.pillName,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          alarm.getFormattedDose(),
                                          style: const TextStyle(
                                              color: Colors.black45,
                                              fontSize: 15),
                                        ),
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
                    );
                  }).toList()
                ],
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddMedicine(null)));
        },
        backgroundColor: Colors.teal,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
