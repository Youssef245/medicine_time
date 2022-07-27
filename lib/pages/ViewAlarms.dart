import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medicine_time/pages/add_medicine.dart';
import 'package:medicine_time/services/medicine_service.dart';

import '../LocalDB.dart';
import '../entities/medicine_alarm.dart';
import '../services/alarm_service.dart';

class ViewAlarms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'ViewAlarms', home: MyViewAlarms());
  }
}

class MyViewAlarms extends StatefulWidget {
  MyViewAlarms();

  @override
  State<MyViewAlarms> createState() => _MyViewAlarmsState();
}

class _MyViewAlarmsState extends State<MyViewAlarms> {
  bool isLoaded = false;
  LocalDB dbHelper = LocalDB();
  List<MedicineAlarm> alarms = [];
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    alarms = await dbHelper.getAlarmsbyDay(date);
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
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
              icon: Icon(
                Icons.date_range,
                color: Colors.white,
              ))
        ],
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
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
                                          onPressed: () async {
                                            AlarmService service =
                                                AlarmService();
                                            LocalDB localdb = LocalDB();
                                            await localdb.deleteAlarm(alarm);
                                            await service.deleteAlarm(alarm);
                                            getData();
                                          },
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
