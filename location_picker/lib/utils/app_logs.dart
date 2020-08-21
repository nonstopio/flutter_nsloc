import '../app.dart';

class AppLogTag {
  static const String INFO = 'I️NFO️';
  static const String API_INFO = 'API INFO';
  static const String ERROR = '❌ERROR❌';
  static const String OPEN_SCREEN = 'OPEN_SCREEN';
  static const String CLOSE_SCREEN = 'CLOSE_SCREEN';
}

///print logs opened screen name on console with tag [AppLogTag.OPEN_SCREEN]
///
///*Should be added in all screens
///
/// Check implementation in screens/splash_screen.dart
openScreenAppLog(String viewName) {
  if (App.instance.appLog)
    logMessage(
      viewName,
      AppLogTag.OPEN_SCREEN,
    );
}

///print logs closed screen name on console with tag [AppLogTag.CLOSE_SCREEN]
///
///*Should be added in all screens
///
closeScreenAppLog(String viewName) {
  if (App.instance.appLog)
    logMessage(
      viewName,
      AppLogTag.CLOSE_SCREEN,
    );
}

///[appLogs,apiLogs,errorLogs] functions should be user to print logs and not `print`

///print Logs on console with tag [AppLogTag.INFO]
///
appLogs(
  Object object, {
  String tag = AppLogTag.INFO,
}) {
  if (App.instance.appLog) {
    String message = "$object";
    logMessage(message, tag);
  }
}

///print Logs on console with tag [AppLogTag.API_INFO]
///
apiLogs(
  Object object, {
  String tag = AppLogTag.API_INFO,
}) {
  String message = "$object";
  if (App.instance.appLog) {
    logMessage(message, tag);
  }
}

///print Logs on console with tag [AppLogTag.ERROR]
///
errorLogs(
  Object object, {
  String tag = AppLogTag.ERROR,
}) {
  String message = "$object";
  if (App.instance.devMode) {
    logMessage(message, tag);
  }
}

///print logs even if the content more then log buffer size
///
logMessage(String message, String tag) {
  if (!App.instance.devMode) return;
  int maxLogSize = 1000;
  for (int i = 0; i <= message.length / maxLogSize; i++) {
    int start = i * maxLogSize;
    int end = (i + 1) * maxLogSize;
    end = end > message.length ? message.length : end;
    print("$tag : ${message.substring(start, end)}");
  }
  print('\n');
}
