import 'package:flutter/material.dart';
import 'package:medicine_time/pages/add_medicine.dart';
import 'package:medicine_time/pages/choose_medicine.dart';
import 'package:medicine_time/pages/home_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print(await Permission.ignoreBatteryOptimizations.request().isGranted);
  runApp(Homepage());
}