import 'package:flutter/material.dart';

import '../app.dart';

///[DevWidget] is shown only if [App.instance.devMode] is enabled
///
///Custom Error widget
///
class DevWidget extends StatelessWidget {
  final Widget child;

  const DevWidget({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (App.instance.devMode) return child;
    return Container();
  }
}
