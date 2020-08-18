import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app_logs.dart';

const String emptyDateString = "1970-01-01";

class DateFormats {
  static const String inTime = 'jm';
  static const String inMonth = 'MMM';
  static const String inYear = 'yyyy';
  static const String inMonthYear = 'MMM yyyy';
  static const String inDayMonthYear = 'dd MMM, yyyy';
  static const String inWithDayOfWeekDayMonthYear = 'EEEE, dd MMM yyyy';
  static const String inSendFormat = 'yyyy-MM-dd';
  static const String inDayMonthYearTime = 'dd MMM yyyy';
  static const String inDayOfWeek = 'EEEE';
  static const String inDayMonth = 'MMMM dd';
  static const String inDay = 'dd';
  static const String serverDateTime = 'yyyy-MM-dd HH:mm:ss';
  static const String inHourMin = 'HH:mm';
}

DateTime toDateTime(String value) {
  DateTime tempDateTime = DateTime.now();

  try {
    tempDateTime = DateTime.parse(value);
  } catch (e, s) {
    appLogs(" toDateTime-->   $value : $e\n$s");
  }

  return tempDateTime;
}

String formatDateFromString({
  @required String format,
  @required String dateTime,
}) {
  try {
    DateTime tempDateTime = toDateTime(dateTime);
    DateFormat dateFormatter = DateFormat(format);
    return dateFormatter.format(tempDateTime);
  } catch (e, s) {
    appLogs(
        " formatDateFromString--> format:$format  dateTime:$dateTime : $e\n$s");
  }
  return emptyDateString;
}

String formatDateFromDateTime({
  @required String format,
  @required DateTime dateTime,
}) {
  try {
    DateFormat dateFormatter = DateFormat(format);
    return dateFormatter.format(dateTime);
  } catch (e, s) {
    appLogs(
        " formatDateFromDateTime --> format$format  dateTime:$dateTime : $e\n$s");
  }
  return emptyDateString;
}
