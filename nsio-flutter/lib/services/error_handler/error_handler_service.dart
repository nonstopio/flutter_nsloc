import 'package:flutter/services.dart';
import 'package:nsio_flutter/utils/app_logs.dart';
import 'package:nsio_flutter/utils/strings.dart';

///[ErrorHandlerService] which  logs any exception occurred at run time
///
class ErrorHandlerService {
  static ErrorHandlerService instance = ErrorHandlerService();

  Future<void> appRecordError(dynamic exception, StackTrace stack,
      {dynamic context}) async {
    String errorTitle;

    if (exception is PlatformException) {
      errorTitle = exception.code;
    } else {
      errorTitle = Strings.crashFinalTitle;
    }
    errorLogs(
        'ErrorHandlerService $errorTitle \nexception: $exception \n stack: $stack \n context: context');
  }
}
