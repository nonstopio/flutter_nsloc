import 'package:flutter/material.dart';
import 'package:nsio_flutter/utils/app_logs.dart';

/// Anything that is to be added in all screen can be added in this mixin
mixin AppScreenMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    openScreenAppLog('$T');
  }

  @override
  void dispose() {
    closeScreenAppLog('$T');
    super.dispose();
  }
}
