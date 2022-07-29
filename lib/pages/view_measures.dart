import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medicine_time/pages/ViewHistory.dart';
import 'package:medicine_time/pages/add_medicine.dart';
import 'package:medicine_time/services/medicine_service.dart';

import '../LocalDB.dart';
import '../entities/Measure.dart';
import '../entities/medicine_alarm.dart';
import '../services/alarm_service.dart';
import 'medicine_taken.dart';

class ViewMeasures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'ViewMeasures', home: MyViewMeasures());
  }
}

class MyViewMeasures extends StatefulWidget {
  MyViewMeasures();

  @override
  State<MyViewMeasures> createState() => _MyViewMeasuresState();
}

class _MyViewMeasuresState extends State<MyViewMeasures> {
  bool isLoaded = false;
  LocalDB dbHelper = LocalDB();
  List<Measure> measures = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    measures = await dbHelper.getMeasures();
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Center(child:  Text("القياسات السابقة",style: TextStyle(color: Colors.white),)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15 , left: 15,right: 15),
        child: SingleChildScrollView(
          child:Column(
            children: [
              ...measures.map((measure) {
                return Column(
                children: [
                  Text(measure.getFormattedDate(),style: const TextStyle(color :Colors.teal,fontSize: 23)),
                  const SizedBox(height: 7,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(" الكرياتنين في الدم : ${measure.createnin}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                    Text(" الترشيح الكبيبي : ${measure.range}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                  ],),
                  const SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(" الضغط : ${measure.pressure}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                      Text(" هيموجلوبين : ${measure.hemoglobin}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                    ],),
                  const SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(" السكر التراكمي : ${measure.glucose}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                      Text(" السكر العشوائي : ${measure.random_glucose}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                    ],),
                  const SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(" صوديوم : ${measure.sodium}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                      Text(" بوتاسيوم : ${measure.potassium}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                    ],),
                  const SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(" كالسيوم : ${measure.calcium}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                      Text(" فوسفات : ${measure.phosphate}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                    ],),
                  const SizedBox(height: 5,),
                  Text(" الوزن : ${measure.weight}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                  const SizedBox(height: 5,),
                  const Divider(color: Colors.teal,thickness: 3,),
                ],
                );
              }).toList()
            ],
          )
    ),
      )
    );
  }
}
