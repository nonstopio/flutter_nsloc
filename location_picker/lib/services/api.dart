import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:location_picker/utils/app_constants.dart';
import 'package:location_picker/utils/keys/api_keys.dart';
import 'package:location_picker/utils/strings.dart';

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

  if (logEnabled) print("getDataFromGETAPI : $apiName with URL = $url");
  if (logEnabled) print("getDataFromGETAPI : $requestHeaders with requestHeaders  = $requestHeaders");

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
      if (logEnabled) print("getDataFromGETAPI : $apiName has Error");

      errorFlag = true;
    }).timeout(new Duration(seconds: timeOutSecond), onTimeout: () async {
      if (logEnabled) print("getDataFromGETAPI : $apiName has TimeOut ");
      timeOutFlag = true;
      return null;
    }).then((response) {
      if (response != null && !timeOutFlag && !errorFlag) {
        if (logEnabled) print("getDataFromGETAPI : $apiName has Response statusCode:${response.statusCode}");
        if (logEnabled) print("getDataFromGETAPI : $apiName has Response body:${response.data}");
        try {
          if (response.data is Map) {
            responseData = response.data;
          } else {
            responseData.putIfAbsent(APIKeys.data, () => response.data);
          }
        } catch (e, s) {
          if (logEnabled) print("getDataFromGETAPI : $apiName has Response Exception:$e \n $s");
          responseData = Map();
        }
        responseData.putIfAbsent("statusCode", () => response.statusCode);
      }
    });
  } catch (exception, stackTrace) {
    if (logEnabled) print(exception);
    if (logEnabled) print(stackTrace);
  }

  if (errorFlag) {
    if (logEnabled) print("getDataFromGETAPI : $apiName Show Error");

    responseData.clear();

    responseData.putIfAbsent("statusCode", () => errorStatusCode);
    responseData.putIfAbsent("message", () => Strings.somethingWentWrong);
  } else if (timeOutFlag) {
    if (logEnabled) print("getDataFromGETAPI : $apiName Show TimeOut $timeOutFlag");

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
      if (logEnabled) print("getDataFromGETAPI : analytics error");
    }
    /* --------AppAnalytics-----------   */

  }

  return responseData;
}
