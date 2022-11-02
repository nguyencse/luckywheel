import 'package:flutter/foundation.dart';

class WheelDebug {
  static void log(String? message) {
    if (kDebugMode) {
      print('LuckyWheel ==> $message');
    }
  }
}
