library medicine_time.globals;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

const FlutterSecureStorage user = FlutterSecureStorage();
const FlutterSecureStorage credintials = FlutterSecureStorage();
const FlutterSecureStorage logged = FlutterSecureStorage();

getDateNow(){
  var formatter = DateFormat.yMMMMd('en_US');
  String formattedDate = formatter.format(DateTime.now());
  return formattedDate;
}