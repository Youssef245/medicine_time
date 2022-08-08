import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medicine_time/pages/ViewHistory.dart';
import 'package:medicine_time/pages/add_medicine.dart';
import 'package:medicine_time/pages/view_plot.dart';
import 'package:medicine_time/services/medicine_service.dart';

import '../LocalDB.dart';
import '../entities/Measure.dart';
import '../entities/medicine_alarm.dart';
import '../services/alarm_service.dart';
import 'medicine_taken.dart';


class PlotOptions extends StatefulWidget {
  List<Measure> measures;

  PlotOptions(this.measures,{Key? key}) : super(key: key);

  @override
  State<PlotOptions> createState() => _MyPlotOptionsState();
}

class _MyPlotOptionsState extends State<PlotOptions> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
              child:Column(
                children: [
                  const SizedBox(height: 7,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      button(" الكرياتنين في الدم",1),
                      button(" الترشيح الكبيبي",2),
                    ],),
                  const SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      button("الضغط",3),
                      button("هيموجلوبين",4),
                    ],),
                  const SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      button("السكر التراكمي",5),
                      button("السكر العشوائي",6),
                    ],),
                  const SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     button("صوديوم",7),
                      button("بوتاسيوم",8),
                    ],),
                  const SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      button("كالسيوم",9),
                      button("فوسفات",10),
                    ],),
                  const SizedBox(height: 5,),
                  button("الوزن",11),
                  const SizedBox(height: 5,),
                  const Divider(color: Colors.teal,thickness: 3,),
                ],
              )
          ),
        )
    );
  }

  Widget button(String text,int choice){
    return  ElevatedButton(child : Text(text,style: const TextStyle(color :Colors.white,fontSize: 18),)
      ,onPressed : (){
        List<Measure> filtered = widget.measures.take(10).toList();
        String title="";
        List<double> chartData=[];
        switch(choice){
          case 1 :
          {
            for (var e in filtered) {chartData.add(e.createnin!);}
            title = "الكرياتينين في الدم";
          }
          break;

          case 2 :
          {
            for (var e in filtered) {chartData.add(e.range!);}
            title = "الترشيح الكبيبي";
          }
          break;

          case 3 :
          {
            for (var e in filtered) {chartData.add(e.createnin!);}
            title = "الضغط";
          }
          break;

          case 4 :
          {
            for (var e in filtered) {chartData.add(e.hemoglobin!);}
            title = "الهيموجلوبين";
          }
          break;

          case 5 :
          {
            for (var e in filtered) {chartData.add(e.glucose!);}
            title = "السكر التراكمي";
          }
          break;

          case 6 :
          {
            for (var e in filtered) {chartData.add(e.random_glucose!);}
            title = "السكر العشوائي";
          }
          break;

          case 7:
          {
            for (var e in filtered) {chartData.add(e.sodium!);}
            title = "صوديوم";
          }
          break;

          case 8 :
          {
            for (var e in filtered) {chartData.add(e.potassium!);}
            title  = "بوتاسيوم";
          }
          break;

          case 9 :
          {
            for (var e in filtered) {chartData.add(e.calcium!);}
            title = "كالسيوم";
          }
          break;

          case 10 :
          {
            for (var e in filtered) {chartData.add(e.phosphate!);}
            title = "فوسفات";
          }
          break;

          case 11 :
          {
            for (var e in filtered) {chartData.add(e.weight!);}
            title = "الوزن";
          }
          break;
        }


        for(int i=chartData.length;i<10;i++) {
          chartData.add(0.0);
        }

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ViewPlot(title, chartData),
        ));
      },
      style: ElevatedButton.styleFrom(primary: Colors.teal),);
  }
}
