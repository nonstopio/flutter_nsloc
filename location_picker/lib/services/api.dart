import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nsio_flutter/utils/app_constants.dart';
import 'package:nsio_flutter/utils/app_logs.dart';
import 'package:nsio_flutter/utils/keys/api_keys.dart';
import 'package:nsio_flutter/utils/strings.dart';

Future<Map<String, dynamic>> getDataFromGETAPI({
  @required String apiName,
  @required BuildContext context,
  Map<String, dynamic> queryParameters,
  bool useBaseURL = true,
  bool logEnabled = true,
  String customErrorMessage,
}) async {
  Map<String, dynamic> responseData = new Map();

  String url = apiName;

  bool errorFlag = false;
  bool timeOutFlag = false;

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  if (logEnabled) apiLogs("getDataFromGETAPI : $apiName with URL = $url");
  if (logEnabled) apiLogs("getDataFromGETAPI : $requestHeaders with requestHeaders  = $requestHeaders");

  try {
    Dio dio = new Dio();

    await dio
        .get(
      Uri.encodeFull(url),
      queryParameters: queryParameters,
      options: Options(
          headers: requestHeaders,
          validateStatus: (status) {
            return status < serverErrorCode;
          }),
    )
        .catchError((onError) {
      if (logEnabled) apiLogs("getDataFromGETAPI : $apiName has Error");

      errorFlag = true;
    }).timeout(new Duration(seconds: timeOutSecond), onTimeout: () async {
      if (logEnabled) apiLogs("getDataFromGETAPI : $apiName has TimeOut ");
      timeOutFlag = true;
      return null;
    }).then((response) {
      if (response != null && !timeOutFlag && !errorFlag) {
        if (logEnabled) apiLogs("getDataFromGETAPI : $apiName has Response statusCode:${response.statusCode}");
        if (logEnabled) apiLogs("getDataFromGETAPI : $apiName has Response body:${response.data}");
        try {
          if (response.data is Map) {
            responseData = response.data;
          } else {
            responseData.putIfAbsent(APIKeys.data, () => response.data);
          }
        } catch (e, s) {
          if (logEnabled) apiLogs("getDataFromGETAPI : $apiName has Response Exception:$e \n $s");
          responseData = Map();
        }
        responseData.putIfAbsent("statusCode", () => response.statusCode);
      }
    });
  } catch (exception, stackTrace) {
    if (logEnabled) apiLogs(exception);
    if (logEnabled) apiLogs(stackTrace);
  }

  if (errorFlag) {
    if (logEnabled) apiLogs("getDataFromGETAPI : $apiName Show Error");

    responseData.clear();

    responseData.putIfAbsent("statusCode", () => errorStatusCode);
    responseData.putIfAbsent("message", () => Strings.somethingWentWrong);
  } else if (timeOutFlag) {
    if (logEnabled) apiLogs("getDataFromGETAPI : $apiName Show TimeOut $timeOutFlag");

    responseData.clear();

    responseData.putIfAbsent("statusCode", () => timeOutCode);
    responseData.putIfAbsent("message", () => Strings.timeOutMessage);
  }

  int statusCode = responseData['statusCode'];

  if (statusCode != 200) {
    /* --------AppAnalytics-----------   */
    try {
      Map<String, dynamic> apiData = Map();
      apiData.putIfAbsent("apiName", () => apiName);
      apiData.putIfAbsent("queryParameters", () => queryParameters);
      apiData.putIfAbsent("url", () => url);
      apiData.putIfAbsent("statusCode", () => statusCode);
      apiData.putIfAbsent("message", () => responseData['message']);
    } catch (e) {
      if (logEnabled) apiLogs("getDataFromGETAPI : analytics error");
    }
    /* --------AppAnalytics-----------   */

  }

  return responseData;
}
