import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medicine_time/pages/ViewHistory.dart';
import 'package:medicine_time/pages/add_medicine.dart';
import 'package:medicine_time/pages/plot_options.dart';
import 'package:medicine_time/services/medicine_service.dart';

import '../LocalDB.dart';
import '../entities/Measure.dart';
import '../entities/medicine_alarm.dart';
import '../services/alarm_service.dart';
import 'medicine_taken.dart';


class ViewMeasures extends StatefulWidget {
  ViewMeasures();

  @override
  State<ViewMeasures> createState() => _MyViewMeasuresState();
}

class _MyViewMeasuresState extends State<ViewMeasures> {
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
                    if(measure.createnin!=0.0) Text(" الكرياتنين في الدم : ${measure.createnin}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                    if(measure.range!=0.0) Text(" الترشيح الكبيبي : ${measure.range}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                  ],),
                  const SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if(measure.pressure!="0.0/0.0") Text(" الضغط : ${measure.pressure}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                      if(measure.hemoglobin!=0.0) Text(" هيموجلوبين : ${measure.hemoglobin}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                    ],),
                  const SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if(measure.glucose!=0.0) Text(" السكر التراكمي : ${measure.glucose}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                      if(measure.random_glucose!=0.0) Text(" السكر العشوائي : ${measure.random_glucose}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                    ],),
                  const SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if(measure.sodium!=0.0) Text(" صوديوم : ${measure.sodium}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                      if(measure.potassium!=0.0) Text(" بوتاسيوم : ${measure.potassium}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                    ],),
                  const SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if(measure.calcium!=0.0) Text(" كالسيوم : ${measure.calcium}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                      if(measure.phosphate!=0.0) Text(" فوسفات : ${measure.phosphate}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                    ],),
                  const SizedBox(height: 5,),
                  if(measure.weight!=0.0) Text(" الوزن : ${measure.weight}",style: const TextStyle(color :Colors.black,fontSize: 18),),
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
