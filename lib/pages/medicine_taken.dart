import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medicine_time/pages/add_medicine.dart';
import 'package:medicine_time/services/medicine_service.dart';

import '../LocalDB.dart';
import '../entities/medicine_alarm.dart';
import '../services/alarm_service.dart';

class MedicineTaken extends StatelessWidget {
  MedicineAlarm alarm;
  MedicineTaken(this.alarm);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'MedicineTaken', home: MyMedicineTaken(alarm));
  }
}

class MyMedicineTaken extends StatefulWidget {
  MedicineAlarm alarm;
  MyMedicineTaken(this.alarm);

  @override
  State<MyMedicineTaken> createState() => _MyMedicineTakenState();
}

class _MyMedicineTakenState extends State<MyMedicineTaken> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
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
                              widget.alarm.getStringTime(),
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
                                        widget.alarm.pillName,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        widget.alarm.getFormattedDose(),
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
                                  TextButton(onPressed: (){}, child:
                                  Image.asset('images/image_reminder_configure.png',height: 40 , width: 40,)),
                                  TextButton(onPressed: (){}, child:
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
        )
      );
  }
}
