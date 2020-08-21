import 'package:flutter/material.dart';
import 'package:nsio_flutter/common_widgets/app_screen_mixin.dart';
import 'package:screen_loader/screen_loader.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AppScreenMixin<HomeScreen>, ScreenLoader<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Example of how screen loader works.
    performFuture(() async => await Future.delayed(Duration(seconds: 3)));
  }

  @override
  Widget screen(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Placeholder(),
      ),
    );
  }
}
