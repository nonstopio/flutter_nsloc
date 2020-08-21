import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_logs.dart';

setFocus(BuildContext context, {FocusNode focusNode}) {
  FocusScope.of(context).requestFocus(focusNode ?? FocusNode());
}

bool isFormValid(key) {
  final form = key.currentState;
  if (form.validate()) {
    form.save();
    appLogs('$key isFormValid:true');
    return true;
  }
  errorLogs('$key isFormValid:false');
  return false;
}

String getJsonFromMap(Map mapData) {
  String data = "";
  try {
    data = json.encode(mapData);
  } catch (e, s) {
    errorLogs("Error in getJsonFromMap\n\n *$mapData* \n\n $e\n\n$s");
  }
  return data;
}

Map getMapFromJson(String mapData) {
  Map data = Map();
  try {
    if (mapData == null || mapData == "") return data;
    data = json.decode(mapData);
  } catch (e, s) {
    errorLogs("Error in getMapFromJson\n\n *$mapData* \n\n $e\n\n$s");
  }
  return data;
}

int toInt(Object value) {
  if (value != null) {
    try {
      int number = int.parse('$value');
      return number;
    } on Exception catch (e, s) {
      errorLogs("toInt Exception : $e\n$s");
    }
  }
  errorLogs("Error in toInt $value");
  return 0;
}

double toDouble(Object value) {
  if (value != null) {
    try {
      double number = double.parse('$value') ?? 0.0;
      return number;
    } on Exception catch (e, s) {
      errorLogs("toDouble Exception : $e\n$s");
    }
  }
  errorLogs("Error in toDouble $value");
  return 0;
}

DateTime toDateTimeFromString(String value) {
  apiLogs("toDateTimeFromString value is $value");
  DateTime tempDateTime = DateTime.now();
  try {
    if (value == null) {
      return DateTime.now();
    } else {
      value = value.toString().replaceAll("/", "-");
    }
    tempDateTime = DateTime.parse(value);
  } catch (e, s) {
    errorLogs("Error in toDateTimeFromString ${e.toString()}\n$s");
    return tempDateTime;
  }
  errorLogs("Error in toDateTimeFromString $value");
  return tempDateTime;
}
