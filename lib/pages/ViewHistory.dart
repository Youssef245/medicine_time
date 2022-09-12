import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medicine_time/entities/history.dart';
import 'package:medicine_time/pages/add_medicine.dart';
import 'package:medicine_time/services/medicine_service.dart';

import '../LocalDB.dart';
import '../entities/medicine_alarm.dart';
import '../services/alarm_service.dart';
import 'medicine_taken.dart';

class ViewHistory extends StatefulWidget {
  ViewHistory();

  @override
  State<ViewHistory> createState() => _MyViewHistoryState();
}

class _MyViewHistoryState extends State<ViewHistory > {
  bool isLoaded = false;
  LocalDB dbHelper = LocalDB();
  List<History> histories = [];
  DateTime date =
  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<String> filterOptions = [
    "كل الأدوية",
    "أدوية تم أخذها",
    "أدوية لم يتم أخذها"
  ];
  String? chosenFilter;
  List<History> filteredHistory = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    chosenFilter = filterOptions.first;
    histories = await dbHelper.getHistories();
    //histories.sort((a, b) => a.getdate().compareTo(b.getdate()));
    histories = histories.reversed.toList();
    filteredHistory=histories;
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
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
            DropdownButton<String>(
                items: filterOptions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: chosenFilter,
                onChanged: (String? newValue) {
                  setState(() {
                    chosenFilter = newValue!;
                    if(chosenFilter==filterOptions.first) {
                      filteredHistory = histories;
                    } else if (chosenFilter==filterOptions.last) {
                      filteredHistory = histories.where((e) => e.action==0).toList();
                    } else {
                      filteredHistory = histories.where((e) => e.action==1).toList();
                    }
                  });
                }),
            ...filteredHistory.map((history) {
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
                            padding: const EdgeInsets.only(left: 5,right : 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  history.getStringTime(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 35),
                                ),
                                Text(
                                  history.getFormattedDate(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: Colors.teal),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(right :8.0),
                            child: Row(
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
                                          history.pillName,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          history.getFormattedDose(),
                                          style: const TextStyle(
                                              color: Colors.black45,
                                              fontSize: 15),
                                        ),],),
                                  ],
                                ),
                        history.action==1 ?  Image.asset('images/image_reminder_taken.png',height: 40 , width: 40,)
                                : Image.asset('images/image_reminder_not_taken.png',height: 40 , width: 40,),
                    ],
                            ),
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
    );
  }
}
