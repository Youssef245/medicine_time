import 'package:flutter/material.dart';
import 'package:medicine_time/LocalDB.dart';
import 'package:medicine_time/entities/history.dart';
import 'package:medicine_time/entities/medicine_alarm.dart';
import 'package:medicine_time/pages/LoginPage.dart';
import 'package:medicine_time/pages/ViewAlarms.dart';
import 'package:medicine_time/pages/add_medicine.dart';
import 'package:medicine_time/globals.dart' as globals;
import 'package:medicine_time/services/alarm_service.dart';
import 'package:medicine_time/services/history_service.dart';

class Homepage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',
        routes: {
          '/ViewAlarms': (context) => ViewAlarms(),
        },
        home:MyHomepage()
    );

  }

}


class MyHomepage extends StatefulWidget{
  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  bool isLoaded = false;
  List<_HomePageItem> items = [_HomePageItem("الأدوية", "images/medicines.png","ViewAlarms"),
    _HomePageItem("حسابي", "images/users.png",""),
    _HomePageItem("الأعراض و الآثار الجانبية", "images/symptoms1.png",""),
    _HomePageItem("القياسات", "images/measures.png",""),
    _HomePageItem("اسأل الطبيب او الصيدلي", "images/measures.png",""),
    _HomePageItem("معلومات ونصائح", "images/knowledge.png",""),
    _HomePageItem("عن التطبيق", "images/about.png",""),
    _HomePageItem("استبيان سهولة الاستخدام", "images/survey.png",""),
  ];
  
  @override
  void initState() {
    sendOffline();
    setState(() {
      isLoaded = true;
    });
  }
  
  sendOffline () async {
    LocalDB dbHelper = LocalDB();
    AlarmService alarmService = AlarmService();
    List<MedicineAlarm> offlineAlarms = await dbHelper.getOfflineAlarms();
    offlineAlarms.forEach((element) async {await alarmService.createAlarm(element.toJson());});

    HistoryService historyService = HistoryService();
    List<History> offlineHistory = await dbHelper.getOfflineHistories();
    offlineHistory.forEach((element) async { await historyService.createHistory(element.toJson());});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoaded ? SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30,),
              ElevatedButton(onPressed: () async {
                await globals.user.write(key: 'logged', value: "false");
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    LoginPage()), (Route<dynamic> route) => false);
              }, child: Text("خروج",style: const TextStyle(color: Colors.teal),),
                style: ElevatedButton.styleFrom(primary: Colors.white70),),
              Image.asset("images/home.png",
              width: 200,
              height: 200,),
              for(int i=0;i<items.length;i=i+2)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(child: cardWidget(items[i+1],context)),
                    Flexible(child: cardWidget(items[i],context)),
                  ],
                )
            ],
          ),
        ) : const Center(child: CircularProgressIndicator() ,),
      );
  }

  Widget cardWidget (_HomePageItem item,BuildContext context)
  {
    return Container(
      child: GestureDetector(
        child: Card(
          color: Colors.white,
          elevation: 3,
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Flexible( child: Image.asset(item.assetName,
                width: 100,
                height: 100,),),
              const SizedBox(height: 10,),
              Flexible( child: Text(item.value, style: const TextStyle(
                  fontWeight: FontWeight.bold ),),
              )
            ],
          ),
        ),
        onTap: (){
          Navigator.of(context);
          Navigator.pushNamed(context, '/${item.pageTitle}');
        },
      ),
      width: 150,
      height: 150,
    );
  }
}

class _HomePageItem {
  String value;
  String assetName;
  String pageTitle;
  _HomePageItem(this.value,this.assetName,this.pageTitle);
}