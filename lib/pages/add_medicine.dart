import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:medicine_time/LocalDB.dart';
import 'package:medicine_time/entities/medicine_alarm.dart';
import 'package:medicine_time/pages/ViewAlarms.dart';
import 'package:medicine_time/pages/home_page.dart';
import 'package:medicine_time/pages/medicine_taken.dart';
import 'package:medicine_time/services/alarm_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';
import 'package:medicine_time/globals.dart' as globals;

import 'choose_medicine.dart';

class AddMedicine extends StatefulWidget{
  String? chosenMedicine;

  AddMedicine(this.chosenMedicine, {Key? key}) : super(key: key);

  @override
  State<AddMedicine> createState() => _MyAddMedicineState();
}

class _MyAddMedicineState extends State<AddMedicine> {
  List<TimeOfDay> timesPickers = [TimeOfDay.now(),TimeOfDay.now(),TimeOfDay.now(),TimeOfDay.now(),TimeOfDay.now(),TimeOfDay.now()];
  List<String> dose_units = ["مجم" ,"جرام" ,"مجم/جرام" ,"مل" ,"مجم/مل" ,"ميكروجرام/مل" ,"ميكروجرام" ,"وحدة دولية/مل"
    ,"مجم/مجم" ,"مجم/جرام" ,"جرام/جرام" ,"%"];
  String? dose_units_value = "مجم";
  String? times = "مرة";
  bool pressed = false;

  LocalDB dbHelper = LocalDB();

  List<String> dose_units2 =["قرص", "كبسول", "حقنة/أمبول", "وحدة","حبيبات/ملعقة","كيس", "شراب/ملعقة", "نقط",
    "محلول", "بخاخ/بخة", "لبوس", "كريم/مرهم"];
  String? dose_units2_value = "قرص";

  List <_DayOfWeek> days_of_week = [_DayOfWeek("سبت",false,6),
    _DayOfWeek("جمعة", false, 5),
    _DayOfWeek("خميس", false, 4),
    _DayOfWeek("أربعاء", false, 3),
    _DayOfWeek("ثلاثاء", false, 2),
    _DayOfWeek("أثنين", false, 1),
    _DayOfWeek("أحد", false, 7)];

  bool everyday = false;
  bool everyOtherDay = false;
  bool backButton = true;
  bool errorHappened = false;

  TextEditingController? dose_quantity = TextEditingController();
  TextEditingController? dose_quantity2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => backButton,
      child: Scaffold(
        body: SingleChildScrollView(
            child:Column(
              children: [
                firstCard(context),
                const SizedBox(height: 20,),
                secondCard(),
                const SizedBox(height: 20,),
                thirdCard(context),
                const SizedBox(height: 20,),
                ElevatedButton(onPressed: pressed ? null : addAlarm, child: const Text(
                  "أضف الدواء",
                  style:
                  TextStyle(color: Colors.white, fontSize: 18),
                ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                      minimumSize: const Size(144, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      )),)
              ],
            )
        ),
      ),
    );
  }

  Widget firstCard (BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.only(top : 50.0),
      child: Card(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children:  [
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Text("اسم الدواء",style:
              TextStyle(
                  fontSize: 15,
                  color: Colors.teal
              ),),
            ),
            Center(
              child: widget.chosenMedicine==null ? TextButton(
                onPressed: () {
                  Navigator.of(context).pop;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChooseMedicine()));
                },
                child: const Text("اضغط لإضافة الدواء",style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    decoration: TextDecoration.underline),),
              ) :
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChooseMedicine()));
                },
                child: Text(widget.chosenMedicine!,style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,),),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                    items: dose_units
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: dose_units_value,
                    onChanged: (String? newValue) {
                      setState(() {
                        dose_units_value = newValue!;
                      });
                    }),
                Container(width: 80,
                    child: TextFormField(decoration: const InputDecoration(
                      hintText: "أدخل التركيز",),controller: dose_quantity,keyboardType: TextInputType.number,)),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                    items: dose_units2
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: dose_units2_value,
                    onChanged: (String? newValue) {
                      setState(() {
                        dose_units2_value = newValue!;
                      });
                    }),
                Container(width: 80,
                    child: TextFormField(decoration: const InputDecoration(
                      hintText: "أدخل الجرعة",),controller: dose_quantity2,keyboardType: TextInputType.number,)),
              ],
            ),
            const SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }

  Widget secondCard()
  {
    return Card(
      color: Colors.white,
      child: Column(
        children: [
          const Text("أيام أخذ الدواء",style: TextStyle(fontSize: 15, color: Colors.teal),),
          /*CheckboxListTile(value: everyOtherDay, onChanged: (bool? value) {
            setState(() {
              everyOtherDay = value!;
            });
          },
            title: const Text("كل يومين"),
          ),*/
          if(!everyOtherDay) CheckboxListTile(value: everyday, onChanged: (bool? value) {
            setState(() {
              everyday = value!;
              for(int a=0;a<7;a++)
              {
                days_of_week[a].chosen = value;
              }
            });
          },
            title: const Text("كل يوم"),
          ),
          if(!everyOtherDay) Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...days_of_week.map((day) {
                int i = days_of_week.indexOf(day);
                return Flexible(
                  child: Card(
                    shape: const CircleBorder(),
                    color: days_of_week[i].chosen ? Colors.teal : Colors.white,
                    child: TextButton(onPressed: (){
                      setState(() {
                        days_of_week[i].chosen=!days_of_week[i].chosen;
                      }); },
                        child: Text(day.day, style : TextStyle(fontSize: 10, color: days_of_week[i].chosen ? Colors.white : Colors.teal ),)
                    ),
                  ),
                );
              }).toList()
            ],
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }

  Widget thirdCard(BuildContext context)
  {
    return Card(
      color: Colors.white,
      child: Column(
        children: [
          const Text("عدد المرات",style: TextStyle(fontSize: 15, color: Colors.teal),),
          DropdownButton<String>(
              items: ["مرة","مرتين","ثلاث مرات","أربع مرات","خمس مرات","ست مرات"]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: times,
              onChanged: (String? newValue) {
                setState(() {
                  times = newValue!;
                });
              }),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for(int z=0;z<getNumber(times!);z++)
                Flexible(
                  child: TextButton(onPressed: ()async {
                    final TimeOfDay? newTime = await showTimePicker(
                      context: context,
                      initialTime: timesPickers[z],
                    );
                    if (newTime != null) {
                      setState(() {
                        timesPickers[z] = newTime;
                      });
                    }
                  }, child: Text("${timesPickers[z].hour}:${timesPickers[z].minute}",style: const TextStyle(color: Colors.black)),),
                )
            ],
          ),
          errorHappened ? Container(
            color: Colors.white,
            child: const Text("فشلت إضافة الدواء"
              , style: TextStyle(color: Colors.red,fontSize: 20),),
          ) : const Text(""),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }

  int getNumber(String string)
  {
    if(string=="مرة") {
      return 1;
    } else if (string=="مرتين") {
      return 2;
    } else if (string=="ثلاث مرات") {
      return 3;
    }
    else if (string=="أربع مرات") {
      return 4;
    }
    else if (string=="خمس مرات") {
      return 5;
    }
    else {
      return 6;
    }
  }

  addAlarm() async {
    final AlarmService service = AlarmService();
    int alarm_id = await service.getLastID();
    var now = DateTime.now();
    String? id = await globals.user.read(key: "id");
    var formatter = DateFormat.yMMMMd('en_US');
    String formattedDate = formatter.format(now);
    List <_DayOfWeek> selectedDays = days_of_week.where((element) => element.chosen).toList();
    String quantity1,quantity2;
    if(dose_quantity!.text=="") {
      quantity1="0";
    } else {
      quantity1=dose_quantity!.text;
    }

    if(dose_quantity2!.text=="") {
      quantity2="0";
    } else {
      quantity2=dose_quantity2!.text;
    }

    if(widget.chosenMedicine!=null&&selectedDays.isNotEmpty)
    {
      setState(() {
        pressed = true;
        backButton = false;
      });
      for(int i=0;i<getNumber(times!);i++)
      {
        alarm_id++;
        if(everyOtherDay)
        {
          int wDay = DateTime.now().weekday;
          selectedDays = days_of_week.where((element) => element.number==wDay).toList();
        }
        // Add Medicine for Every Chosen Time and Day
        for(int j=0;j<selectedDays.length;j++)
        {
          MedicineAlarm alarm = MedicineAlarm.name2(timesPickers[i].hour, selectedDays[j].number, timesPickers[i].minute, widget.chosenMedicine, quantity1,
              dose_units_value, dose_units2_value, formattedDate, quantity2 , alarm_id,int.parse(id!));
          alarm.everyOtherDay= everyOtherDay? 1 :0 ;
          int? al_id = await dbHelper.createAlarm(alarm);
          alarm.id = al_id;
          await service.createAlarm(alarm);
          handleNotification(timesPickers[i],selectedDays[j].number,al_id,alarm);
        }
      }
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (context) => ViewAlarms()),
              (route) => route.isFirst);
    }
    else
    {
      setState(() {
        errorHappened = true;
      });
    }
  }

  handleNotification(TimeOfDay time , int dayofWeek,int al_id,MedicineAlarm alarm) async {

    if(DateTime.now().weekday > dayofWeek) {
      dayofWeek=dayofWeek+7;
    }
    int dayofweekdiff = DateTime.now().weekday - dayofWeek;
    dayofweekdiff = dayofweekdiff.abs();
    DateTime alarmdate =DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, time.hour, time.minute);
    int nowInMinutes = TimeOfDay.now().hour * 60 + TimeOfDay.now().minute;
    int timeinMinutes = time.hour* 60 + time.minute;
    alarmdate = alarmdate.add(Duration(days: dayofweekdiff));
    if(timeinMinutes<nowInMinutes&&dayofweekdiff==0) {
      alarmdate = alarmdate.add(const Duration(days: 7));
    }

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =  InitializationSettings(
      android: initializationSettingsAndroid,);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: Homepage().selectNotification);
   /* */

    //DateTime alarmDate = DateTime.now().add(Duration (minutes: 2));
    print(tz.TZDateTime.from(alarmdate, tz.getLocation('Africa/Cairo')));


    await flutterLocalNotificationsPlugin.zonedSchedule(
        al_id,
        'حان وقت الدواء',
        'اضغط هنا!',
        tz.TZDateTime.from(alarmdate, tz.getLocation('Africa/Cairo')),
         NotificationDetails(
            android: AndroidNotificationDetails(
              'ALARMS_${al_id}', 'Alarm_${al_id}',
              channelDescription: 'Alarm Channel for ${al_id}',importance: Importance.high, priority: Priority.high,
              playSound: true,
              sound: RawResourceAndroidNotificationSound('cuco_sound'),
            )),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        payload: "Alarm ${alarm.alarmId.toString()}",
        matchDateTimeComponents: alarm.everyOtherDay==0 ?  DateTimeComponents.dayOfWeekAndTime : null);
    
  }
}

class _DayOfWeek {
  String day;
  bool chosen;
  int number;

  _DayOfWeek(this.day, this.chosen, this.number);
}