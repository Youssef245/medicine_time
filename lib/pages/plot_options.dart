import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medicine_time/pages/ViewHistory.dart';
import 'package:medicine_time/pages/add_medicine.dart';
import 'package:medicine_time/pages/pressure_plot.dart';
import 'package:medicine_time/pages/view_plot.dart';
import 'package:medicine_time/services/medicine_service.dart';

import '../LocalDB.dart';
import '../entities/Measure.dart';
import '../entities/medicine_alarm.dart';
import '../services/alarm_service.dart';
import 'medicine_taken.dart';


class PlotOptions extends StatefulWidget {

  PlotOptions({Key? key}) : super(key: key);

  @override
  State<PlotOptions> createState() => _MyPlotOptionsState();
}

class _MyPlotOptionsState extends State<PlotOptions> {
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
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: SingleChildScrollView(
                child: isLoaded ? Column(
                  children: [
                    Center(
                      child: Image.asset("images/stats.png",
                        width: 150,
                        height: 150,
                      ),
                    ),
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
                  ],
                ) : const Center(child: CircularProgressIndicator(),)
            ),
          ),
        )
    );
  }

  Widget button(String text,int choice){
    bool pressure=false;
    return  ElevatedButton(child : Text(text,style: const TextStyle(color :Colors.white,fontSize: 18),)
      ,onPressed : (){
        List<Measure> filtered = measures.take(10).toList();
        String title="";
        List<double> chartData=[];
        List<double> chartData2=[];
        List<String> dates=[];
        switch(choice){
          case 1 :
            {
              for (var e in filtered) {
                if(e.createnin!=0.0)
                {
                  chartData.add(e.createnin!);
                  dates.add(e.getFormattedDate());
                }
              }
              title = "الكرياتينين في الدم";
            }
            break;

          case 2 :
            {
              for (var e in filtered) {
                if(e.range!=0.0) {
                  chartData.add(e.range!);
                  dates.add(e.getFormattedDate());
                }
              }
              title = "الترشيح الكبيبي";
            }
            break;

          case 3 :
            {
              for (var e in filtered) {
                if(e.pressure!="0.0/0.0") {
                  chartData.add(double.parse(e.pressure!.split("/")[0]));
                  chartData2.add(double.parse(e.pressure!.split("/")[1]));
                  dates.add(e.getFormattedDate());
                }
              }
              title = "الضغط";
              pressure=true;
            }
            break;

          case 4 :
            {
              for (var e in filtered) {
                if(e.hemoglobin!=0.0) {
                  chartData.add(e.hemoglobin!);
                  dates.add(e.getFormattedDate());
                }
              }
              title = "الهيموجلوبين";
            }
            break;

          case 5 :
            {
              for (var e in filtered) {
                if(e.glucose!=0.0) {
                  chartData.add(e.glucose!);
                  dates.add(e.getFormattedDate());
                }
              }
              title = "السكر التراكمي";
            }
            break;

          case 6 :
            {
              for (var e in filtered) {
                if(e.random_glucose!=0.0) {
                  chartData.add(e.random_glucose!);
                  dates.add(e.getFormattedDate());
                }
              }
              title = "السكر العشوائي";
            }
            break;

          case 7:
            {
              for (var e in filtered) {
                if(e.sodium!=0.0) {
                  chartData.add(e.sodium!);
                  dates.add(e.getFormattedDate());
                }
              }
              title = "صوديوم";
            }
            break;

          case 8 :
            {
              for (var e in filtered) {
                if(e.potassium!=0.0) {
                  chartData.add(e.potassium!);
                  dates.add(e.getFormattedDate());
                }
              }
              title  = "بوتاسيوم";
            }
            break;

          case 9 :
            {
              for (var e in filtered) {
                if(e.calcium!=0.0) {
                  chartData.add(e.calcium!);
                  dates.add(e.getFormattedDate());
                }
              }
              title = "كالسيوم";
            }
            break;

          case 10 :
            {
              for (var e in filtered) {
                if(e.phosphate!=0.0) {
                  chartData.add(e.phosphate!);
                  dates.add(e.getFormattedDate());
                }
              }
              title = "فوسفات";
            }
            break;

          case 11 :
            {
              for (var e in filtered) {
                if(e.weight!=0.0) {
                  chartData.add(e.weight!);
                  dates.add(e.getFormattedDate());
                }
              }
              title = "الوزن";
            }
            break;
        }


        for(int i=chartData.length;i<10;i++) {
          chartData.add(0.0);
          dates.add("");
        }

        if(pressure)
        {
          for(int i=chartData2.length;i<10;i++) {
            chartData2.add(0.0);
          }
           Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PressurePlot(title, chartData,chartData2,dates),
        ));
        }
        else
        {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewPlot(title, chartData,dates),
          ));
        }
      },
      style: ElevatedButton.styleFrom(primary: Colors.teal),);
  }
}
