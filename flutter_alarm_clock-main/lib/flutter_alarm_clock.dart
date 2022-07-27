import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class FlutterAlarmClock {
  static const MethodChannel _channel = MethodChannel('flutter_alarm_clock');

  /// Show Alarms
  ///
  /// Opens default clock app showing alarms.
  static void showAlarms() {
    try {
      if (Platform.isAndroid) {
        _channel.invokeMethod('showAlarms');
      } else {
        throw UnimplementedError;
      }
    } on PlatformException {
      debugPrint("Error showing alarms.");
    }
  }

  /// Create an alarm.
  ///
  /// 'hour' specifies alarm hour
  /// 'minutes' specifies alarm minutes
  /// 'title' specifies alarm title - optional
  /// 'skipUi' specifies whether clock app should open or not - optional
  static void createAlarm(int hour, int minutes, List<int> days,
      {String title = "", bool skipUi = true}) {
    try {
      if (Platform.isAndroid) {
        _channel.invokeMethod('createAlarm', <String, dynamic>{
	        'days' : days,
          'hour': hour,
          'minutes': minutes,
          'title': title,
          'skipUi': skipUi,
        });
      } else {
        throw UnimplementedError;
      }
    } on PlatformException {
      debugPrint("Error creating an alarm.");
    }
  }


  static void deleteAlarm(int hour, int minutes, {bool skipUi = true}) {
    try {
      if (Platform.isAndroid) {
        _channel.invokeMethod('deleteAlarm', <String, dynamic>{
          'hour': hour,
          'minutes': minutes,
          'skipUi': skipUi,
        });
      } else {
        throw UnimplementedError;
      }
    } on PlatformException {
      debugPrint("Error creating a timer.");
    }
  }
}
