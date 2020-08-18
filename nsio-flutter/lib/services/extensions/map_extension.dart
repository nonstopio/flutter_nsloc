import 'package:flutter/material.dart';
import 'package:nsio_flutter/utils/app_logs.dart';
import 'package:nsio_flutter/utils/methods.dart';

const bool defaultBool = false;
const int defaultInt = 0;
const double defaultDouble = 0;
const String defaultString = '';

/// extension methods for Map
///
extension Interpreter on Map {
  /// Reads a [key] value of [bool] type from [Map].
  ///
  /// If value is NULL or not [bool] type return default value [defaultBool]
  ///
  bool getBool(String key) {
    Map data = this;
    if (data == null) {
      data = {};
    }
    if (data.containsKey(key)) if (data[key] is bool)
      return this[key] ?? defaultBool;
    errorLogs("Map.getBool[$key] has incorrect data : $this");
    return defaultBool;
  }

  /// Reads a [key] value of [int] type from [Map].
  ///
  /// If value is NULL or not [int] type return default value [defaultInt]
  ///
  int getInt(String key) {
    Map data = this;
    if (data == null) {
      data = {};
    }
    if (data.containsKey(key)) return toInt(data[key]);
    errorLogs("Map.getInt[$key] has incorrect data : $this");
    return defaultInt;
  }

  /// Reads a [key] value of [double] type from [Map].
  ///
  /// If value is NULL or not [double] type return default value [defaultDouble]
  ///
  double getDouble(String key) {
    Map data = this;
    if (data == null) {
      data = {};
    }
    if (data.containsKey(key)) return toDouble(data[key]);
    errorLogs("Map.getDouble[$key] has incorrect data : $this");
    return defaultDouble;
  }

  /// Reads a [key] value of [String] type from [Map].
  ///
  /// If value is NULL or not [String] type return default value [defaultString]
  ///.
  String getString(String key) {
    Map data = this;
    if (data == null) {
      data = {};
    }
    if (data.containsKey(key)) if (data[key] is String)
      return data[key] ?? defaultString;
    errorLogs("Map.getString[$key] has incorrect data : $this");
    return defaultString;
  }

  /// Reads a [key] value of [List] type from [Map].
  ///
  /// If value is NULL or not [List] type return default value [defaultString]
  ///
  List<T> getList<T>(String key) {
    Map data = this;
    if (data == null) {
      data = {};
    }
    if (data.containsKey(key)) if (data[key] is List<T>)
      return data[key] ?? <T>[];
    errorLogs("Map.getString[$key] has incorrect data : $this");

    return <T>[];
  }

  ///Add value to map if value is not null
  ///
  T add<T>({@required String key, @required T value}) =>
      this.putIfAbsent(key, () => value);
}
