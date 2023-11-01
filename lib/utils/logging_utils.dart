import 'dart:developer';

class LoggingUtils {
  static void logStartFunction(String functionName) {
    var current = DateTime.now();
    log('[Timestamp : ${current.hour}:${current.minute}:${current.second}] ON START FUNCTION $functionName');
  }

  static void logEndFunction(String functionName) {
    var current = DateTime.now();
    log('[Timestamp : ${current.hour}:${current.minute}:${current.second}] ON END FUNCTION $functionName');
  }

  static void logDebugValue(String data, String activity) {
    var current = DateTime.now();
    log('[Timestamp : ${current.hour}:${current.minute}:${current.second}] [Activity $activity] [Data : ${data.toString()}]');
  }

  static void logError(String activity, String errMessage) {
    var current = DateTime.now();
    log('[Timestamp : ${current.hour}:${current.minute}:${current.second}] [Error Message on $activity : $errMessage]');
  }
}
