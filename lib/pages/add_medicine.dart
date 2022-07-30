import 'dart:async';
import 'dart:developer' as developer;
import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:medicine_time/LocalDB.dart';
import 'package:medicine_time/entities/medicine_alarm.dart';
import 'package:medicine_time/pages/ViewAlarms.dart';
import 'package:medicine_time/pages/home_page.dart';
import 'package:medicine_time/services/alarm_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import 'choose_medicine.dart';

class AddMedicine extends StatelessWidget {
  String? chosenMedicine;

  AddMedicine(this.chosenMedicine);

  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'AddMedicine',
        home: MyAddMedicine(chosenMedicine)
    );
  }
}
class MyAddMedicine extends StatefulWidget{
  String? chosenMedicine;

  MyAddMedicine(this.chosenMedicine);

  @override
  State<MyAddMedicine> createState() => _MyAddMedicineState();
}

class _MyAddMedicineState extends State<MyAddMedicine> {
  List<TimeOfDay> timesPickers = [TimeOfDay.now(),TimeOfDay.now(),TimeOfDay.now()];
  List<String> dose_units = ["مجم" ,"جرام" ,"مجم/جرام" ,"مل" ,"مجم/مل" ,"ميكروجرام/مل" ,"ميكروجرام" ,"وحدة دولية/مل"
    ,"مجم/مجم" ,"مجم/جرام" ,"جرام/جرام" ,"%"];
  String? dose_units_value = "مجم";
  String? times = "مرة";

  LocalDB dbHelper = LocalDB();

  List<String> dose_units2 =["قرص", "كبسول", "حقنة/أمبول", "وحدة","حبيبات/ملعقة","كيس", "شراب/ملعقة", "نقط",
    "محلول", "بخاخ/بخة", "لبوس", "كريم/مرهم"];
  String? dose_units2_value = "قرص";

  List <_DayofWeek> days_of_week = [_DayofWeek("سبت",false,6),
    _DayofWeek("جمعة", false, 5),
    _DayofWeek("خميس", false, 4),
    _DayofWeek("أربعاء", false, 3),
    _DayofWeek("ثلاثاء", false, 2),
    _DayofWeek("أثنين", false, 1),
    _DayofWeek("أحد", false, 7)];

  bool everyday = false;

  TextEditingController? dose_quantity = TextEditingController();
  TextEditingController? dose_quantity2 = TextEditingController();

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;


  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child:Column(
            children: [
              firstCard(context),
              const SizedBox(height: 20,),
              secondCard(),
              const SizedBox(height: 20,),
              thirdCard(context),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: addAlarm, child: const Text(
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChooseMedicine()));
                },
                child: const Text("اضغط لإضافة الدواء",style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    decoration: TextDecoration.underline),),
              ) :
              TextButton(
                onPressed: (){
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
          CheckboxListTile(value: everyday, onChanged: (bool? value) {
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
          Row(
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
              items: ["مرة","مرتين","ثلاث مرات"]
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
                TextButton(onPressed: ()async {
                  final TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: timesPickers[z],
                  );
                  if (newTime != null) {
                    setState(() {
                      timesPickers[z] = newTime;
                    });
                  }
                }, child: Text("${timesPickers[z].hour}:${timesPickers[z].minute}",style: const TextStyle(color: Colors.black)),)
            ],
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }

  int getNumber(String string)
  {
    if(string=="مرة") return 1;
    else if (string=="مرتين") return 2;
    else return 3;
  }

  addAlarm() async {
    final AlarmService service = AlarmService();
    int alarm_id = await service.getLastID();
    var now = DateTime.now();
    var formatter = DateFormat.yMMMMd('en_US');
    String formattedDate = formatter.format(now);
    List <_DayofWeek> selectedDays = days_of_week.where((element) => element.chosen).toList();
    String quantity1,quantity2;
    if(dose_quantity!.text=="")
      quantity1="0";
    else
      quantity1=dose_quantity!.text;

    if(dose_quantity2!.text=="")
      quantity2="0";
    else
      quantity2=dose_quantity2!.text;

    if(widget.chosenMedicine!=null)
    {
      for(int i=0;i<getNumber(times!);i++)
      {
        alarm_id++;
        for(int j=0;j<selectedDays.length;j++)
        {
          MedicineAlarm alarm = MedicineAlarm.name2(timesPickers[i].hour, selectedDays[j].number, timesPickers[i].minute, widget.chosenMedicine, quantity1,
              dose_units_value, dose_units2_value, formattedDate, quantity2 , alarm_id,3000);
          int? al_id = await dbHelper.createAlarm(alarm);
          alarm.id = al_id;
          if(_connectionStatus==ConnectivityResult.mobile||_connectionStatus==ConnectivityResult.wifi)
          {
            await service.createAlarm(alarm.toJson());
          }
          else
          {
            await dbHelper.createOfflineAlarm(alarm);
          }
          handleNotification(timesPickers[i],selectedDays[j].number,al_id);
        }
      }
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ViewAlarms()));
    }
  }

  handleNotification(TimeOfDay time , int dayofWeek,int al_id) async {

    if(DateTime.now().weekday > dayofWeek)
      dayofWeek=dayofWeek+7;
    int dayofweekdiff = DateTime.now().weekday - dayofWeek;
    dayofweekdiff = dayofweekdiff.abs();
    DateTime alarmdate =DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, time.hour, time.minute);
    int nowInMinutes = TimeOfDay.now().hour * 60 + TimeOfDay.now().minute;
    int timeinMinutes = time.hour* 60 + time.minute;
    alarmdate = alarmdate.add(Duration(days: dayofweekdiff));
    if(timeinMinutes<nowInMinutes&&dayofweekdiff==0)
      alarmdate = alarmdate.add(const Duration(days: 7));

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =  InitializationSettings(
      android: initializationSettingsAndroid,);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
   /* */

    //DateTime alarmDate = DateTime.now().add(Duration (minutes: 2));
    print(DateTime.now().add(DateTime.now().difference(alarmdate)));

    await flutterLocalNotificationsPlugin.zonedSchedule(
        al_id,
        'حان وقت الدواء',
        'اضغط هنا!',
        tz.TZDateTime.from(DateTime.now().add(alarmdate.difference(DateTime.now())), tz.getLocation('Africa/Cairo')),
         NotificationDetails(
            android: AndroidNotificationDetails(
              'ALARMS_${al_id}', 'Alarm_${al_id}',
              channelDescription: 'Alarm Channel for ${al_id}',importance: Importance.high, priority: Priority.high,
              playSound: true,
              sound: RawResourceAndroidNotificationSound('cuco_sound'),
            )),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();


  }

  void selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => Homepage()),
    );
  }
}

class _DayofWeek {
  String day;
  bool chosen;
  int number;

  _DayofWeek(this.day, this.chosen, this.number);
}