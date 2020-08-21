import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:nsio_flutter/common_widgets/app_screen_mixin.dart';
import 'package:nsio_flutter/screens/location/location_screen.dart';
import 'package:nsio_flutter/utils/app_constants.dart';
import 'package:nsio_flutter/utils/app_logs.dart';
import 'package:nsio_flutter/utils/app_routes.dart';
import 'package:nsio_flutter/utils/assets.dart';
import 'package:nsio_flutter/utils/keys/api_keys.dart';
import 'package:nsio_flutter/utils/screens.dart';
import 'package:nsio_flutter/utils/sizes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin<SplashScreen>, AppScreenMixin<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirectUser();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Sizes.initScreenAwareSizes(context);
  }

  @override
  void dispose() {
    super.dispose();
    errorLogs(Screens.SplashScreen);
  }

  _redirectUser() {
    Future.delayed(
      AppConstants.splashDelay,
      () => AppRoutes.makeFirst(
        context,
        MyMap(
          googleMapsKey: APIKeys.googleMapsAPIKey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image(image: AssetImage(Assets.nonstopioLogo)),
            ),
          ],
        ),
      ),
    );
  }
}
