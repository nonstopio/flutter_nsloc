import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_logs.dart';

///[AppRoutes] an util class to navigate between screen

class AppRoutes {
  /// Push the given route onto the navigator.
  ///
  static void push(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context) => screen),
    );
  }

  /// Replace the current route of the navigator by pushing the given route and
  /// then disposing the previous route.
  ///
  static void replace(BuildContext context, Widget screen) {
    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(builder: (context) => screen),
    );
  }

  /// Replace the all route of the navigator by pushing the given route and
  /// then disposing all the previous route.
  ///
  static void makeFirst(BuildContext context, Widget screen) {
    Navigator.of(context).popUntil((predicate) => predicate.isFirst);
    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(builder: (context) => screen),
    );
  }

  /// Pop the top-most route off the navigator.
  ///
  static void pop<T>(BuildContext context, {T data}) {
    try {
      Navigator.of(context).pop(data);
    } catch (e, s) {
      errorLogs("pop faied : $e\n$s");
    }
  }

  /// Consults the current route's [Route.willPop] method, and acts accordingly,
  ///
  static void mayBePop(BuildContext context) {
    Navigator.of(context).maybePop();
  }
}
