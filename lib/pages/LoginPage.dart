import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicine_time/pages/home_page.dart';
import 'package:medicine_time/pages/static_view.dart';
import 'package:medicine_time/services/user_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../entities/user.dart';
import 'package:medicine_time/globals.dart' as globals;


class LoginPage extends StatefulWidget{
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  User? user;
  bool save = false;
  bool showPassword = true;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    initializeControllers();
  }

  initializeControllers() async {
    String? name = await globals.credintials.read(key: "name");
    String? password = await globals.credintials.read(key: "password");
    nameController = TextEditingController(text: name);
    passwordController = TextEditingController(text: password);
    setState(() {
      if(nameController.text!=null)
        save=true;
      isLoaded = true;
    });
  }

  login (String name,String password) async {
    UserSerivce service = UserSerivce();
    user = await service.login({
      'name' : name,
      'password' : password,
    });

    if(user != null)
    {
       globals.user.write(key: "name", value: user!.name);
       globals.user.write(key: "id", value: user!.id.toString());
       globals.user.write(key: "logged", value: "true");
      if(save)
         globals.user.write(key: "remember", value: "true");
      else
         globals.user.write(key: "remember", value: "false");
      return "true";
    }

  }

  saveCredentials(String name,String password) async {
    globals.credintials.write(key: "name", value: name);
    globals.credintials.write(key: "password", value: password);
  }
  
  
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.teal,
          resizeToAvoidBottomInset: false,
          body: isLoaded ? Padding(
            padding: const EdgeInsets.only(top : 150),
            child: Center(
              child: Column (
                children: [
                  Image.asset("images/logo2.png",
                  width: 100, height: 100,),
                  const SizedBox(height: 10,),
                Container(
                  width: 300,
                  child: Column(
                    children: [
                      TextFormField( style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                         labelText: "اسم المستخدم",labelStyle: TextStyle(color: Colors.white)),
                        controller: nameController,
                        cursorColor: Colors.white,),
                      const SizedBox(height: 15,),
                      TextFormField(style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                         labelText: "كلمة السر", labelStyle: const TextStyle(color: Colors.white),
                          suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            icon: showPassword ? const Icon(
                              Icons.remove_red_eye,
                              color: Colors.white,
                            ) : const Icon(
                            Icons.visibility_off,
                            color: Colors.white,
                          ),
                          )
                      ),
                        controller: passwordController,
                        obscureText: showPassword ? true : false,
                        cursorColor: Colors.white,
                      ),
                    ],
                  )
                ),
                const SizedBox(height: 10,),
                Container(
                  width: 200,
                  child: CheckboxListTile(side: const BorderSide(color: Colors.white),
                    checkColor: Colors.teal,
                    activeColor: Colors.white,
                    value: save, onChanged: (bool? value) {setState(() {save = value!;});},
                    title: const Text("تذكر كلمة المرور",style:
                      TextStyle(color: Colors.white),),),
                ),
                  const SizedBox(height: 10,),
                 ElevatedButton(onPressed: () async {
                   //setNotification2();
                   //setNotification1();
                   String status = await login(nameController.text, passwordController.text);
                   if(status=="true")
                   {
                     if(save) saveCredentials(nameController.text, passwordController.text);
                     Navigator.of(context).pop();
                     Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                         Homepage()));
                   }
                 }, child: Text("تسجيل الدخول",style: const TextStyle(color: Colors.teal),),
                   style: ElevatedButton.styleFrom(primary: Colors.white70),)
                ],
              ),
            ),
          ) : const Center(child: CircularProgressIndicator(),),
        );
  }

  setNotification1() async
  {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =  InitializationSettings(
      android: initializationSettingsAndroid,);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: Homepage().selectNotification);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        900,
        'هل استخدمتني اليوم؟',
        '',
        _nextInstanceOf1PM(),
        const NotificationDetails(
            android: AndroidNotificationDetails(
              'DidYouUseMe', 'DidYouUseMe',
              channelDescription: 'DidYouUseMe',importance: Importance.high, priority: Priority.high,
              playSound: true,
            )),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "Use");
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  }

  setNotification2() async
  {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =  InitializationSettings(
      android: initializationSettingsAndroid,);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: Homepage().selectNotification);

    Random random = Random();
    int randomNumber = random.nextInt(42);
    final String response = await rootBundle.loadString('assets/statics.json');
    final data = await json.decode(response);
    String title = data['titles'][randomNumber];

    await flutterLocalNotificationsPlugin.zonedSchedule(
        901,
        'هل تعلم؟',
        title,
        _nextInstanceOf6PM(),
        const NotificationDetails(
            android: AndroidNotificationDetails(
              'randomKnowledge', 'randomKnowledge',
              channelDescription: 'randomKnowledge',importance: Importance.high, priority: Priority.high,
              playSound: true,
            )),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "Static ${(randomNumber+1).toString()}");
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  }

  void selectNotification2(String? payload) async {
    if(payload != null)
    {
      debugPrint('notification payload: $payload');
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StaticView(int.parse(payload))),);
    }
  }



  tz.TZDateTime _nextInstanceOf1PM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 13);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
  tz.TZDateTime _nextInstanceOf6PM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 18);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}