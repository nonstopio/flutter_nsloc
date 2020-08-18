import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nsio_flutter/screens/splash_screen.dart';
import 'package:nsio_flutter/services/error_handler/error_handler_service.dart';
import 'package:nsio_flutter/themes/app_theme.dart';
import 'package:nsio_flutter/utils/app_logs.dart';
import 'package:nsio_flutter/utils/strings.dart';
import 'package:package_info/package_info.dart';
import 'package:screen_loader/screen_loader.dart';

import 'common_widgets/app_error_widget.dart';

/// The entry point for accessing App.
///
/// You can get an instance by calling `App.instance`.
///
/// Only one instance should be created for App i.e `App.instance`.
///
class App {
  static App instance = App();

  /// [_appName] app display Name
  ///
  String _appName = 'NonStopIO';

  /// [_version] holds the current version of the app
  /// This must be only initialize using plugin [package_info] to
  /// current version in method initAndRunApp.
  /// This must be only initialize in initAndRunApp.
  ///
  String _version;

  /// [_buildNumber] holds the current version of the app
  /// This must be only initialize using plugin [package_info] to
  /// current version.
  /// This must be only initialize in initAndRunApp.
  ///
  String _buildNumber;

  /// [_devMode] to improve DX (Developer Experience)
  /// and avoid display or log data in production
  /// Example :
  /// ```dart
  ///   if (App.instance.devMode) {
  ///    //Pre-fill username and password for login
  ///    _username='NonStopIO';
  ///    _password='*********';
  ///    }
  /// ```
  /// In production it should be set false.
  /// This must be only initialize in initAndRunApp.
  ///
  bool _devMode;

  ///***** DO NOT USE `print` TO LOG ******
  ///
  /// [_appLog] to print log
  bool _appLog;

  /// [_apiLog] to print api log
  bool _apiLog;

  ///[appName] getter for [_appLog] default  value  is  ''
  String get appName => _appName ?? Strings.isEmpty;

  ///[devMode] getter for [_devMode] default  value  is  false
  bool get devMode => _devMode ?? false;

  ///[appLog] getter for [_appLog] default  value  is  false
  bool get appLog => _appLog ?? false;

  ///[apiLog] getter for [_apiLog] default  value  is  false
  bool get apiLog => _apiLog ?? false;

  ///[version] getter for [_version] default  value  is  ''
  String get version => _version ?? Strings.isEmpty;

  ///[buildNumber] getter for [_buildNumber] default  value  is  ''
  String get buildNumber => _buildNumber ?? Strings.isEmpty;

  ///initialize App variables and run app
  void initAndRunApp({
    @required bool appLog,
    @required bool apiLog,
    @required bool devMode,
  }) {
    runZoned<Future<void>>(
      () async {
        WidgetsFlutterBinding.ensureInitialized();

        /* --------Setting configuration parameters-----------   */
        _devMode = devMode;
        _appLog = appLog;
        _apiLog = apiLog;

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        _version = packageInfo.version;
        _buildNumber = packageInfo.buildNumber;
        /* --------Setting configuration parameters-----------   */

        /* --------Setting View Orientation Portrait-----------   */
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        /* --------Setting View Orientation Portrait-----------   */

        /* --------ErrorWidget-----------   */
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return AppErrorWidget(errorDetails: errorDetails);
        };
        /* --------ErrorWidget-----------   */

        appLogs('''
        AppConfigurations
        Orientation : Portrait
        version : $_version
        buildNumber : $_buildNumber
        devMode : $_devMode
        appLog : $_appLog
        apiLog : $_apiLog
               ''');

        runApp(MyApp());
      },
      onError: ErrorHandlerService.instance.appRecordError,
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenLoaderApp(
      globalLoader: CircularProgressIndicator(),
      app: MaterialApp(
        title: App.instance.appName,
        home: SplashScreen(),
        debugShowCheckedModeBanner: App.instance.devMode,
        theme: appTheme,
      ),
    );
  }
}
