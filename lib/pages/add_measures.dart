import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicine_time/entities/Measure.dart';
import 'package:medicine_time/pages/ViewHistory.dart';
import 'package:medicine_time/pages/add_medicine.dart';
import 'package:medicine_time/pages/view_measures.dart';
import 'package:medicine_time/services/measures_service.dart';
import 'package:medicine_time/services/medicine_service.dart';
import 'package:medicine_time/globals.dart' as globals;

import '../LocalDB.dart';
import '../entities/medicine_alarm.dart';
import '../services/alarm_service.dart';
import 'home_page.dart';
import 'medicine_taken.dart';


class AddMeasures extends StatefulWidget {
  AddMeasures();

  @override
  State<AddMeasures> createState() => _MyAddMeasuresState();
}

class _MyAddMeasuresState extends State<AddMeasures> {
  LocalDB dbHelper = LocalDB();
  DateTime now = DateTime.now();
  TextEditingController sy_pressureController= TextEditingController();
  TextEditingController dia_pressureController= TextEditingController();
  TextEditingController glucoseController= TextEditingController();
  TextEditingController random_glucoseController= TextEditingController();
  TextEditingController sodiumController= TextEditingController();
  TextEditingController potassiumController= TextEditingController();
  TextEditingController phosphateController= TextEditingController();
  TextEditingController createninController= TextEditingController();
  TextEditingController hemoglobinController= TextEditingController();
  TextEditingController weightController= TextEditingController();
  TextEditingController user_idController= TextEditingController();
  TextEditingController inserted_dateController= TextEditingController();
  TextEditingController calciumController= TextEditingController();
  TextEditingController rangeController= TextEditingController();

  List<_inputItem> items = [];



  @override
  void initState() {
    super.initState();
    items = [
      _inputItem.name( "الكرياتينين في الدم", "مجم/ديسيلتر",  createninController),
      _inputItem.name( "معدل الترشيح الكبيبي", "مل/دقيقة",  rangeController),
      _pressureItem("ضغط الدم", "120", "80", dia_pressureController, sy_pressureController),
      _inputItem.name( "السكر التراكمي", "%",  glucoseController),
      _inputItem.name( "السكر العشوائي", "مجم/ديسيلتر",  random_glucoseController),
      _inputItem.name( "الهيموجلوبين", "جرام/ديسيلتر",  hemoglobinController),
      _inputItem.name( "الصوديوم", "ممول/لتر",  sodiumController),
      _inputItem.name( "البوتاسيوم", "ممول/لتر",  potassiumController),
      _inputItem.name( "الكالسيوم", "مجم/ديسيلتر",  calciumController),
      _inputItem.name( "الفوسفات", "مجم/ديسيلتر",  phosphateController),
      _inputItem.name( "الوزن", "كجم",  weightController),
    ];
  }

  registerMeasure() async {
    String? id = await globals.user.read(key: "id");
    var formatter = DateFormat.yMMMMd('en_US');
    String formattedDate = formatter.format(now);
    Measure measure = Measure.name(
        "${getValue(dia_pressureController, true)}/${getValue(sy_pressureController, true)}",
        getValue(glucoseController, false),
        getValue(random_glucoseController, false),
        getValue(sodiumController, false),
        getValue(potassiumController, false),
        getValue(phosphateController, false),
        getValue(createninController, false),
        getValue(hemoglobinController, false),
        getValue(weightController, false),
        int.parse(id!),
        formattedDate,
        getValue(calciumController, false),
        getValue(rangeController, false)
    );
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile||connectivityResult == ConnectivityResult.wifi) {
      MeasuresService service = MeasuresService();
      service.addMeasure(measure.toJson());
    } else{
      await dbHelper.addOfflineMeasure(measure);
    }
     dbHelper.addMeasure(measure);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top : 80),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("images/measures.png",
                width: 150,
                height: 150,
              ),
              inputFields(items),
              ElevatedButton(onPressed: () async {
                registerMeasure();
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                    Homepage()));
              }, child: Text("تسجيل",style: const TextStyle(color: Colors.teal),),
                            style: ElevatedButton.styleFrom(primary: Colors.white70),),
              const SizedBox(height: 15,),
              Align(
                alignment: FractionalOffset.bottomLeft,
                child: ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                      ViewMeasures()));
                }, child: const Text("القياسات السابقة",style:  TextStyle(color: Colors.teal),),
                  style: ElevatedButton.styleFrom(primary: Colors.white70),),
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget inputFields (List<_inputItem> thisItems) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          ...thisItems.map((item) {
            if(item is _pressureItem) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(children: [
                        Container(
                        width: MediaQuery.of(context).size.width/5,
                        height:40,
                        child: TextFormField(decoration:  InputDecoration(hintText: item.label,
                          border: const OutlineInputBorder(borderSide:  BorderSide(width: 2.0),),
                        ),
                        keyboardType:TextInputType.number,
                        controller: item.controller ,),
                        ),
                        const Text("  /  " ,style: TextStyle(color: Colors.teal, fontSize: 20),),
                        Container(
                        width: MediaQuery.of(context).size.width/5,
                        height:40,
                        child: TextFormField(
                          decoration:   InputDecoration(hintText: item.label2,
                          border: const OutlineInputBorder(borderSide:  BorderSide(width: 2.0),),),
                          keyboardType:TextInputType.number,
                        controller: item.controller2 ,
                        textAlignVertical: TextAlignVertical.center),
                )
                ],),
                 Flexible(child: Text(" : ${item.field} ",style: const TextStyle(color: Colors.teal, fontSize: 20),textAlign: TextAlign.justify)),
                    ],
          ),
                const SizedBox(height: 10,)
              ],
            );
          } else {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Container(
                        width: MediaQuery.of(context).size.width,height:40,
                        padding: EdgeInsets.only(left: 10),
                        child: TextFormField(decoration:  InputDecoration(labelText: item.label,
                          border: const OutlineInputBorder(borderSide:  BorderSide(width: 2.0),),),
                        keyboardType:TextInputType.number,
                        controller: item.controller ,),
                        ),
                      ),
                      Flexible(child: Text(" : ${item.field}",style: const TextStyle(color: Colors.teal, fontSize: 20),textAlign: TextAlign.justify)),
                    ],
                  ),
                  const SizedBox(height: 10,)
                ],
              );
              }
              }).toList()
                  ],
                ),
              );
        }

  getValue (TextEditingController controller,bool string)
  {
    if(controller.text.isNotEmpty) {
      if(string) {
        return controller.text;
      } else {
        return double.parse(controller.text);
      }
    } else if (controller.text.isEmpty&&string) {
      return "0.0";
    } else {
      return 0.0;
    }
  }

}

class _inputItem {
  String? field;
  String? label;
  TextEditingController? controller;

  _inputItem();

  _inputItem.name(this.field, this.label, this.controller);
}

class _pressureItem extends _inputItem {

  @override
  String? field;
  @override
  String? label;

  String label2;

  @override
  TextEditingController? controller;

  TextEditingController? controller2;

  _pressureItem(this.field, this.label, this.label2, this.controller, this.controller2);
}
